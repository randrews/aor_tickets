task :load_test_data => :environment do
  Ticket.all.map &:destroy
  User.all.map &:destroy
  Tag.all.map &:destroy

  sql = ActiveRecord::Base.connection
  File.open("sql/tickets.sql").each_line do |line|
    sql.execute(line.strip) unless line.strip.blank?
  end

  %w{randrews cclarke jjones}.each do |login|
    User.create :login=>login
  end

  ids = User.all.map(&:id) + [nil]
  Ticket.all.each do |ticket|
    ticket.update_attribute :user_id, ids.rand
  end

  %w{i18n-related
     complicated
     web_design
     javascript
     performance
     ie_compatibility}.each do |tag|

    Ticket.all.sort{|a,b| rand-0.5}[0..99].each do |ticket|
      Tag.create :ticket_id=>ticket.id, :name=>tag
    end
  end
end
