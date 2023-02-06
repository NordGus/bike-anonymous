source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "rack-cors", "~> 1.1", ">= 1.1.1"
gem "sidekiq", "~> 6.5", ">= 6.5.4"
gem "jwt", "~> 2.4", ">= 2.4.1"
gem "redis-session-store", "~> 0.11.4"
gem "matrix", "~> 0.4"
gem "prawn", "~> 2.4"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "rubocop", "~> 1.36", require: false
end

group :test do
  gem "pdf-inspector", require: "pdf/inspector"
  gem "simplecov", require: false
end
