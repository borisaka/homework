# frozen_string_literal: true

require 'csv'
require_relative '../app'

class Parser
  # Parser class loads file, parse by line and inserts to DB with chunks

  BATCH_SIZE = 1000
  def initialize(path)
    @path = path
    @users = []
    @sessions = []
  end

  def call
    parse
    # Flushing unfinished batches
    insert_users
    insert_sessions
    puts "Setting up foreign keys. It may take a wild"
    update_foreignkeys
  end

  private

  attr_reader :path

  def parse
    CSV.foreach(path) do |row|
      row[0] == 'user' ? append_user(row) : append_session(row)
    end
  end

  def update_foreignkeys
    sql = <<-SQL
      UPDATE sessions s set user_id = u.id from users u
        WHERE s.external_user_id = u.external_id
    SQL
    App.db.execute(sql)
  end

  def append_user(row)
    insert_users if @users.length >= BATCH_SIZE

    @users << [row[1], row[2].strip, row[3].strip, row[4].to_i]
  end

  def append_session(row)
    insert_sessions if @sessions.length >= BATCH_SIZE

    browser_name, browser_version = /(.*) (\d+)$/.match(row[3])[1..]
    @sessions << [row[1], row[2], browser_name.strip, browser_version.strip, row[4].strip, Date.iso8601(row[5])]
  end

  def insert_users
    puts "Inserting #{@users.length} users"
    App.db[:users].import(%i[external_id first_name last_name age], @users)
    @users = []
  end

  def insert_sessions
    puts "Inserting #{@sessions.length} sessions"
    App.db[:sessions].import(%i[external_user_id external_id browser_name browser_version duration visited_at], @sessions)
    @sessions = []
  end
end
