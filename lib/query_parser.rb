class QueryGrammar < Dhaka::Grammar
  precedences do
    left ['or']
    left ['and']
  end

  for_symbol(Dhaka::START_SYMBOL_NAME) do
    query               %w| Query |
    find_id             %w| number |
  end

  for_symbol('Query') do
    intersection        %w| Query and Query |
    union               %w| Query or Query |
    oneclause           %w| Clause |
    parenthesized_query %w| ( Query ) |
  end

  for_symbol('Clause') do
    negated             %w| not Clause |
    tag                 %w| string |
    comparison          %w| string Operator Value |
  end

  for_symbol('Operator') do
    eq_comparator       %w| = |
    like_comparator     %w| like |
  end

  for_symbol('Value') do
    string_value        %w| string |
    number_value        %w| number |
  end
end

logger = Logger.new(STDOUT)
logger.level = Logger::ERROR
logger.formatter = Dhaka::ParserLogOutputFormatter.new

# We pass in a logger set to ERROR so that it doesn't tell us
# about the shift/reduce conflicts (we have precedences set,
# so they're not really a problem)
QueryParser = Dhaka::Parser.new(QueryGrammar, logger)
