class QueryLexerSpecification < Dhaka::LexerSpecification
  # Operators:
  # We'll make a map of each operator, and the thing that matches it.
  # Since these are all really simple (just keywords), we'll do them
  # in a loop.
  operators = { 
    '(' => '\(',
    ')' => '\)',
    '=' => '=',
    'and' => 'and',
    'or' => 'or',
    'not' => 'not',
    'like' => 'like'
  }

  operators.each do |operator, regex|
    for_pattern(regex) do
      create_token(operator)
    end
  end

  # Quoted strings:
  # This complicated regex matches "-delimited strings,
  # with escaped quotes in them. We pull off the quotes
  # and make a token out of it.
  for_pattern(/"([^\\"]|\\[\\"])*"/) do
    raw=current_lexeme.value
    escaped=raw.gsub('\\"','"').gsub('\\\\','\\')
    dequoted=escaped[1..(escaped.length-2)]
    create_token('string',dequoted)
  end

  # Numbers:
  # we'll want to be able to have just a number be a
  # possible query, so we can search a single ID.
  for_pattern(/[0-9]+/) do
    create_token('number')
  end

  # Unquoted strings:
  # Anything with no funny characters in it can be a string
  # without quotes, to make it easier to search on tags.
  for_pattern(/[a-zA-Z0-9_\-]+/) do
    create_token('string')
  end

  # Whitespace:
  # Match any blocks of whitespace (that aren't inside
  # quoted strings; those'll match first) and toss it.
  for_pattern('\s+') do ; end
end

QueryLexer = Dhaka::Lexer.new(QueryLexerSpecification)
