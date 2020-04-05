require 'sidekiq/web'

if Rails.env.production?
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    [username, password] == [ENV['SIDEKIQ_USERNAME'], ENV['SIDEKIQ_PASSWORD']]
  end
end
