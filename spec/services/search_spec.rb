require 'rails_helper'

RSpec.describe SearchService, elasticsearch: true do
  let!(:user) { create(:user) }

  before do
    @question1 = create(:question, title: 'some title', body: 'some text', author: user)
    @question2 = create(:question, title: 'new question title', body: 'some text', author: user)
    Question.__elasticsearch__.refresh_index!

    @results = SearchService.new.search('some text')
  end

  it 'returns array of results' do
    expect(@results).to be_an_instance_of(Array)
    expect(@results.size).to eq 2
  end

  it 'returns mapped data in result' do
    expect(@results[0][:title]).to eq(@question1.title)
    expect(@results[0][:details]).to eq(@question1.body)

    expect(@results[1][:title]).to eq(@question2.title)
    expect(@results[1][:details]).to eq(@question2.body)
  end

end
