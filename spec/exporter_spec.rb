require 'app/exporter'
require 'app/total_report'

RSpec.describe Exporter do
  let(:report) { instance_double(TotalReport, report: { data: 'ok' }) }
  let(:path) { File.join('.', 'tmp', 'data.json') }

  subject(:result) { described_class.new(path).call }

  before do
    allow(TotalReport).to receive(:new).and_return(report)
  end

  it do
    result
    data = JSON.parse(File.read(path), symbolize_names: true)
    expect(data).to eq(data: 'ok')
  end
end