require 'dotenv/load'
require 'logger'

require_relative 'lib/db'

class App
  class << self
    attr_reader :db

    def logger
      @logger ||= Logger.new(STDOUT).tap { |logger| logger.level = Logger::DEBUG}
    end

    def setup!(test: false)
      @db = DB.connect(test ? ENV['TEST_DB'] : ENV['DATABASE'])
    end
  end
end