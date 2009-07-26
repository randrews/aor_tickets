namespace :parser do
  task :lex => :environment do
    query=ENV['QUERY'] rescue ""

    QueryLexer.lex(query).each do |token|
      puts token
    end
  end
end
