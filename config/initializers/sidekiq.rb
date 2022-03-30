# bundle exec sidekiq command => this file executed

redis_params = {
    url: "redis://localhost:6379",  
}

# Server config
Sidekiq.configure_server do |config|
    config.redis = redis_params
end

# Client config
Sidekiq.configure_client do |config|
    config.redis = redis_params
end

# scheduling
schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

