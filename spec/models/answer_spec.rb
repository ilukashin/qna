require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe 'table rules' do
    it { should have_db_column(:body).of_type(:text).with_options(null: false) }
    it { should have_db_column(:is_best).of_type(:boolean).with_options(null: false, default: false) }
  end

  it 'should has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
