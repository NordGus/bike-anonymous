ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "sidekiq/testing"
require 'simplecov'

SimpleCov.start

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def login_token(user)
    post login_api_session_index_url,
         params: {
           username: users(user).username,
           password: "secret"
         }

    response.parsed_body["jwt"]
  end

  def teardown
    Sidekiq::Worker.clear_all
  end
end
