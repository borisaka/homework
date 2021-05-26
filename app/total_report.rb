# frozen_string_literal: true

require_relative 'base_report'
require_relative 'session_report'

class TotalReport < BaseReport

  field :users_count do
    App.db[:users].count
  end

  field :browsers_count do
    browser_list_rel.count
  end

  field :max_session_duration do
    App.db[:sessions].select { max(:duration) }.first[:max]
  end

  field :browser_list do
    browser_list_rel.all.map { |row| "#{row[:browser_name]} #{row[:browser_version]}".upcase }.join('. ')
  end

  field :users do
    result = {}
    App.db[:users].each do |user|
      result[ :"#{user[:first_name]}_#{user[:last_name]}"] = SessionReport.new(user[:id]).report
    end
    result 
  end

  private

  def browser_list_rel
    App.db[:sessions].select(:browser_name, :browser_version).order_by(:browser_name).distinct
  end
end