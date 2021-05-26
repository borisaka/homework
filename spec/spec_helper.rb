# require 'lib/db'
# require 'rspec'

$LOAD_PATH.unshift(File.dirname(__dir__))
require 'database_cleaner-sequel'
require 'app'

RSpec.configure do |config|
  config.before(:suite) do
    Sequel.extension :migration
    App.setup!(test: true)
    DatabaseCleaner[:sequel].db = App.db
    DatabaseCleaner[:sequel].strategy = :transaction
    Sequel::Migrator.run(App.db, './migrations', use_transactions: true)
  end

  config.before(:example) do
    DatabaseCleaner[:sequel].start
  end

  config.after(:example) do
    DatabaseCleaner[:sequel].clean
  end
end