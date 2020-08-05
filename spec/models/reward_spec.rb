require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of :name }

  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it 'should have one attached picture' do
    expect(Reward.new.picture).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
