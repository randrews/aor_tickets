logger = Logger.new(STDOUT)
logger.level = Logger::ERROR
logger.formatter = Dhaka::ParserLogOutputFormatter.new

# We pass in a logger set to ERROR so that it doesn't tell us
# about the shift/reduce conflicts (we have precedences set,
# so they're not really a problem)
QueryParser = Dhaka::Parser.new(QueryGrammar, logger)
