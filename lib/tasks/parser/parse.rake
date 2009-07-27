namespace :parser do
  task :parse => :environment do
    query=ENV['QUERY'] rescue ""
    filename=ENV['FILENAME'] || 'parse.dot'

    tree = QueryParser.parse(QueryLexer.lex(query))
    puts tree.inspect if tree.is_a? Dhaka::ParseErrorResult

    File.open(filename, 'w') do |file|
      file << tree.to_dot
    end

    `dot -Tpng -o#{filename}.png #{filename}`
    `rm #{filename}`
  end
end
