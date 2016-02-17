require 'faker'
require 'csv'

namespace :mock do
  task :recipients do
    log = Logger.new($stdout)
    CSV.open("mock.csv", 'wb') do |csv|
      csv << ['id', 'email', 'first_name', 'last_name', ]
      (1..100000).each do |i|
        log.info("Generated #{i}") if i % 1000 == 0
        csv << [Faker::Number.number(14), Faker::Internet.email, Faker::Name.first_name, Faker::Name.last_name, 'male', Faker::Internet.ip_v4_address]
      end
    end
  end
end
