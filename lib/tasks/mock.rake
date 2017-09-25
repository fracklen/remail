# require 'faker'
require 'csv'

count = (ENV['MOCK_COUNT'] || 1000).to_i

FIRST_NAMES = %w(Jack James Oliver Lewis Logan Harry Noah Leo Charlie Alexander Olivia Emily Sophie Isla Ava Amelia Jessica Ella Lucy Charlotte)
SUR_NAMES = %w(DOUGLAS FLEMING JENSEN VARGAS BYRD DAVIDSON HOPKINS MAY TERRY HERRERA WADE SOTO WALTERS CURTIS NEAL CALDWELL LOWE JENNINGS BARNETT GRAVES JIMENEZ HORTON SHELTON BARRETT OBRIEN CASTRO SUTTON GREGORY MCKINNEY LUCAS MILES CRAIG RODRIQUEZ CHAMBERS HOLT LAMBERT FLETCHER WATTS BATES HALE RHODES PENA BECK NEWMAN HAYNES MCDANIEL MENDEZ BUSH VAUGHN PARKS DAWSON SANTIAGO NORRIS HARDY LOVE STEELE CURRY POWERS SCHULTZ BARKER GUZMAN PAGE MUNOZ BALL KELLER CHANDLER WEBER LEONARD WALSH LYONS RAMSEY WOLFE SCHNEIDER MULLINS BENSON SHARP MIRANDA)

def gen_record(i)
  first_name = gen_name(i)
  sur_name = gen_surname(i)
  [i, gen_mail(first_name, sur_name, i), first_name, sur_name]
end

def gen_mail(first_name, sur_name, i)
  "#{first_name.downcase}.#{sur_name.downcase}#{i}@gmail.com"
end

def gen_name(i)
  "#{FIRST_NAMES.sample.capitalize}"
end

def gen_surname(i)
  SUR_NAMES.sample.capitalize
end

namespace :mock do
  task :recipients do
    log = Logger.new($stdout)
    CSV.open("mock.csv", 'wb') do |csv|
      csv << ['id', 'email', 'first_name', 'last_name']
      (1..count).each do |i|
        log.info("Generated #{i}") if i % 100 == 0
        csv << gen_record(i)
      end
    end
  end
end
