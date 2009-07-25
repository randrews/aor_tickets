task :load_test_data => :environment do
  Ticket.all.map &:destroy
  User.all.map &:destroy

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
end
