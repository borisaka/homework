require 'app/session_report'
RSpec.describe SessionReport do
  let(:dates) { [Time.now - 60, Time.now - 80000, Time.now - 180000] }
  subject { described_class.new(App.db[:users].all[0][:id]).report }

  let(:basic_response) do
    {
      sessions_count: 2,
      total_duration:25,
      max_duration: 15,
      browser_list: "Chrome 10, Chrome 11",
      dates_list: "2021-05-26, 2021-05-25"
    }
  end

  let(:user_id) { App.db[:users].all[0][:id] }

  before do
    # allow_any_instance_of(SessionReport).to receive(:report).and_return(data: 'ok')
    App.db[:users].import([:first_name, :external_id], [['a', 1]])
    App.db[:sessions].import(
      [:browser_name, :browser_version, :duration, :visited_at, :user_id],
      [['Chrome', '11', 10, dates[0], user_id],
      ['Chrome', '10', 15, dates[1], user_id]]
    )
  end

  context 'when chrome only' do
    it do
      is_expected.to eq(
        use_ie: false,
        only_chrome: true,
        sessions_count: 2,
        total_duration: 25,
        max_duration: 15,
        browser_list: "Chrome 10, Chrome 11",
        dates_list: "2021-05-26, 2021-05-25"
      )
    end
  end

  context 'with ie' do
    before do
      App.db[:sessions].insert(
        user_id: user_id,
        browser_name: 'Internet Explorer',
        browser_version: '6',
        duration: 25,
        visited_at: dates[2]
      )
    end

    it do
      is_expected.to eq(basic_response.merge(
        use_ie: true,
        only_chrome: false,
        browser_list: "Chrome 10, Chrome 11, Internet Explorer 6",
        dates_list: "2021-05-26, 2021-05-25, 2021-05-24",
        sessions_count: 3,
        total_duration: 50,
        max_duration: 25,
      ))
    end
  end
end