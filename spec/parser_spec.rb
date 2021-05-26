# frozen_string_literal: true

# require 'spec_helper'

require 'app/parser'

RSpec.describe do
  # let(:db) { App.db }
  before { Parser.new(File.join(__dir__, 'assets', 'data.txt')).call }

  it 'saves users' do
    users = App.db[:users].order(:external_id).all
    expect(users[0]).to include(
      external_id: 0,
      first_name: 'Uncle',
      last_name: 'Bens',
      age: 21
    )
    expect(users[1]).to include(
      external_id: 1,
      first_name: 'John',
      last_name: 'Doe',
      age: 32
    )

    expect(users[2]).to include(
      external_id: 2,
      first_name: 'Edik',
      last_name: 'Shuvalov',
      age: 27
    )
  end

  it 'saves sessions' do
    sessions = App.db[:sessions].order(:external_user_id, :external_id).all

    expect(sessions[0]).to include(
      external_id: 0,
      external_user_id: 0,
      browser_name: 'Internet Explorer',
      browser_version: '9',
      duration: 98,
      visited_at: instance_of(Date),
      user_id: App.db[:users].where(external_id: 0).first[:id]
    )

    expect(sessions[1]).to include(
      external_id: 0,
      external_user_id: 1,
      browser_name: 'Chrome',
      browser_version: '9',
      duration: 98,
      visited_at: instance_of(Date),
      user_id: App.db[:users].where(external_id: 1).first[:id]
    )
  end
end