require 'gmail'

namespace :gmail do
  task :test do
    log = Logger.new($stdout)
    username = ENV['GMAIL_USERNAME']
    password = ENV['GMAIL_PASSWORD']
    gmail = Gmail.connect!(username, password)
    # play with your gmail...
    log.info("Logged in: #{gmail.logged_in?}")

    email = gmail.compose do
      to "fmn.adwork@gmail.com"
      subject "Vi er flyvende!"
      body "YEAH!!"
    end
    email.deliver!

    gmail.logout
  end
end
