# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

group :development do
  gem 'irbtools-more', require: 'irbtools/binding'
end

group :development, :test do
  gem 'rspec', '~> 3.10'
  gem 'database_cleaner-sequel', '~> 2.0'
  gem 'rubocop', '~> 1.15'
  gem 'rubocop-rspec', '~> 2.3'
end

gem 'sequel', '~> 5.44'
gem 'sequel_pg', '~> 1.14', :require=>'sequel'
gem 'rake'
gem 'dotenv', '~> 2.7', '>= 2.7.6'
gem 'yajl-ruby', '~> 1.4', '>= 1.4.1', require: 'yajl'