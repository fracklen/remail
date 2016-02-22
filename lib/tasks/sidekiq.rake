namespace :sidekiq do
  task :clear do
    Sidekiq.redis do |conn|
      conn.flushdb
    end
  end
end
