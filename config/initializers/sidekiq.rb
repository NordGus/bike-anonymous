require 'sidekiq/web'

redis_configuration = {
  url:  ENV['BIKES_ANONYMOUS_SIDEKIQ_REDIS_URL'],
  port: ENV['BIKES_ANONYMOUS_SIDEKIQ_REDIS_PORT'],
  db:   ENV['BIKES_ANONYMOUS_SIDEKIQ_REDIS_DATABASE']
}

Sidekiq.configure_client do |config|
  config.redis = redis_configuration
end

Sidekiq.configure_server do |config|
  config.redis = redis_configuration
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(ENV["BIKES_ANONYMOUS_SIDEKIQ_USERNAME"])
  ) &
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(ENV["BIKES_ANONYMOUS_SIDEKIQ_PASSWORD"])
  )
end
