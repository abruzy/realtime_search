Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://red-cvul80q4d50c73b2n850:6379" } }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://red-cvul80q4d50c73b2n850:6379" } }
end