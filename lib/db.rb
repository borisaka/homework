# frozen_string_literal: true
require 'sequel'
require_relative '../app'

class DB
  # Database operator
  # need
  POSTGRES_DB = ENV['POSTGRES_DB']
  def self.connect(db_name)
    new(db_name).connect
  end

  def self.create(db_name)
    raise 'Could not create postgres DB' if db_name == POSTGRES_DB
    master_db = connect(POSTGRES_DB)
    master_db.execute("CREATE DATABASE #{db_name}")
    App.logger.info("DATABASE #{db_name} was created")
    connect(db_name)

    rescue Sequel::DatabaseError => error
    if error.cause.is_a?(PG::DuplicateDatabase)
      App.logger.error("DATABASE #{db_name} already exists")
    else
      raise error
    end
  end

  def self.drop(db_name)
    raise 'Could not drop postgres DB' if db_name == POSTGRES_DB #ENV['POSTGRES_DB']
    master_db = connect(POSTGRES_DB)
    master_db.execute("DROP DATABASE #{db_name}")
    App.logger.info("DATABASE #{db_name} was droped")
    rescue Sequel::DatabaseError => error

    if error.cause.is_a?(PG::InvalidCatalogName)
      App.logger.error("DATABASE #{db_name} does not exists")
    else
      raise error
    end
  end

  def initialize(db_name)
    @db_name = db_name
  end

  # def exec_on_postgres(query)
  #   raise 'Not postgres db' unless db_name == POSTGRES_DB
  #   db = connect
  #   db.execute(query)
  #   rescue Sequel::DatabaseError => error
  #     if error.cause.is_a?(PG::InvalidCatalogName)
  #       App.logger.error("DATABASE #{db_name} does not exists")
  #     elsif error.cause.is_a?(PG::DuplicateDatabase)
  #       App.logger.error("DATABASE #{db_name} already exists")
  #     else
  #       raise error
  #     end
  # end

  def connect
    Sequel.connect(
      adapter: 'postgres',
      host: ENV['DB_HOST'],
      port: ENV['DB_PORT'],
      user: ENV['DB_USER'],
      password: ENV['DB_PASSWORD'],
      database: db_name,
      logger: App.logger
    )
  end

  private

  attr_reader :db_name
end