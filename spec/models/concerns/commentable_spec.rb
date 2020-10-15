require 'rails_helper'

shared_examples_for 'commentable' do
  it { should have_many(:votes).dependent(:destroy) }
end
