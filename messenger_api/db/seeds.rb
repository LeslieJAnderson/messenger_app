def run
    create_users
    create_messages
end

def create_users
    FactoryBot.create(:user, username: 'DariaM')
    FactoryBot.create(:user, username: 'JaneLane')
    FactoryBot.create(:user, username: 'QuinnM')
end

def create_messages
  FactoryBot.create(:message, from_user_id: "2", to_user_id: "1", created_at: Time.now - 30.days, content: "Should we get our fortunes told?")
  FactoryBot.create(:message, from_user_id: "1", to_user_id: "2", created_at: Time.now - 29.days, content: "I'll pass. Knowing the present is bad enough.")
  FactoryBot.create(:message, from_user_id: "3", to_user_id: "1", created_at: Time.now - 15.days,content: "Marco will probably pick me up in a limo of one of those cute little sports cars.")
  FactoryBot.create(:message, from_user_id: "1", to_user_id: "3", created_at: Time.now - 16.days, content: "To go with his cute little brain.")
end


if !Rails.env.development?

    puts
    puts "You may only run the seeder on the development environment."
    puts

elsif !User.exists?

    run

else

    puts
    puts "Can't run seeder because records already exist."
    puts "To destroy your database and run the seeder:"
    puts
    puts "  Delete messenger_api/db/development.sqlite3"
    puts "  $ rake db:migrate"
    puts "  $ rake db:seed"
    puts

end