require 'app/total_report'
RSpec.describe TotalReport do
  subject { described_class.new.report }

  before do
    allow_any_instance_of(SessionReport).to receive(:report).and_return(data: 'ok')
    App.db[:users].import([:first_name, :external_id], [['a', 1], ['b', 2]])
    App.db[:sessions].import(
      [:browser_name, :browser_version],
      [['Internet explorer', '11'],
      ['Chrome', '10'],]
    )
  end

  it do
    is_expected.to eq(
      {
        users_count: 2,
        browsers_count: 2,
        max_session_duration: nil,
        browser_list: "CHROME 10. INTERNET EXPLORER 11",
        users: {  a_: { data: "ok" }, b_: { data: "ok" } }
      }
    )
  end
end