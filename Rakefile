# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
require 'dotenv/tasks'
require_relative 'app'
require_relative 'app/parser'
require_relative 'app/exporter'
require_relative 'lib/db'


# Bundler.require!

task :environment do
  App.setup!
end

task import_data: :environment do
  Parser.new(File.join('.', 'data', 'data_large.txt')).call
end

task report: :environment do
  Exporter.new(File.join('.', 'out', 'report.json')).call
end

namespace :db do

  task create: :dotenv do
    DB.create(ENV['DATABASE'])
    DB.create(ENV['TEST_DB'])
  end

  task drop: :dotenv do
    # binding.irb
    DB.drop(ENV['DATABASE'])
    DB.drop(ENV['TEST_DB'])
  end

  task migrate: :environment do
    Sequel.extension :migration
    Sequel::Migrator.run(App.db, './migrations', use_transactions: true)
  end
end
