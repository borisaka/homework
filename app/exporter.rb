# frozen_string_literal: true

require 'yajl'
require 'yajl/gzip'
require_relative 'total_report'

class Exporter
  def initialize(path)
    @path = path
  end

  def call
    report = TotalReport.new.report
    File.open(path, 'w') do |file|
      # Yajl::Gzip::StreamWriter.encode(report, file)
      Yajl::Encoder.encode(report, file)
    end
  end

  private

  attr_reader :path
end