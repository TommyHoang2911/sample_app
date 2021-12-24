source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}
ruby "2.7.0"
gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap-sass", "~> 3.4.1"
gem "config"
gem "faker", "2.1.2"
gem "figaro"
gem "jbuilder", "~> 2.7"
gem "pagy"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.4", ">= 6.0.4.1"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"
group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
  gem "sqlite3", "~> 1.4"
end
group :development do
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end
group :test do
  gem "capybara", ">= 2.15"
  gem "guard", "2.16.2"
  gem "guard-minitest", "2.4.6"
  gem "minitest", "5.11.3"
  gem "minitest-reporters", "1.3.8"
  gem "rails-controller-testing", "1.0.5"
  gem "selenium-webdriver"
  gem "webdrivers"
end
group :production do
  gem "pg", "1.2.3"
end
