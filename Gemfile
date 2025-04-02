source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.3.0"

# Rails
gem "rails", "~> 7.2.0" # Rails のバージョンを正しく指定

# Database
group :development, :test do
  gem "sqlite3", ">= 1.4"
end

group :production do
  gem "pg", ">= 1.3.5" # 最新の安定バージョンを使用
end

# Web server
gem "puma", ">= 5.0"

# Other gems
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "rack-cors"
gem "bcrypt", "~> 3.1.20"
gem "jwt"

gem 'google-cloud-storage'
# gem "image_processing", "~> 1.2" # 必要に応じてコメントアウトを解除

# Development gems
group :development do
  gem "debug", platforms: %i[mri windows], require: false
end

# Testing gems
group :test do
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end