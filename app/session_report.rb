# frozen_string_literal: true

require_relative 'base_report'

class SessionReport < BaseReport
  def initialize(id)
    @id = id
  end

  field :sessions_count do
    @sessions_count ||= relation.count
  end

  field :total_duration do
    relation.select { sum(:duration) }.first[:sum]
  end

  field :max_duration do
    relation.select { max(:duration) }.first[:max]
  end

  field :browser_list do
    relation.select(:browser_name, :browser_version)
            .distinct
            .all
            .map { |row| "#{row[:browser_name]} #{row[:browser_version]}" }
            .join(', ')
  end

  field :use_ie do
    relation.where(browser_name: 'Internet Explorer').count.positive?
  end

  field :only_chrome do
    relation.where(browser_name: 'Chrome').count == sessions_count
  end

  field :dates_list do
    relation.select(:visited_at).order_by(Sequel.desc :visited_at).all.map{ |row| row[:visited_at].iso8601 }.join(', ')
  end

  private

  # def sessions_count
  #   @sessions_count ||= relation.count
  # end

  def relation
    App.db[:sessions].where(user_id: @id)
  end
end