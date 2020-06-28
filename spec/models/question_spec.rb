require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'table rules' do
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
    it { should have_db_column(:body).of_type(:text).with_options(null: false) }
  end

end
