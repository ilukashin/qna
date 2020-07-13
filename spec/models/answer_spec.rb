require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'table rules' do
    it { should have_db_column(:body).of_type(:text).with_options(null: false) }
    it { should have_db_column(:is_best).of_type(:boolean).with_options(null: false, default: false) }
  end
end
