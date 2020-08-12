require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:described_model) { create(described_class.to_s.downcase.to_sym) }

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:vote) { create(:vote, votable: described_model, user: user, value: 1) }
  let(:vote2) { create(:vote, votable: described_model, user: user2, value: -1) }

  before { described_model.votes = [vote, vote2] }

  describe 'Votable#upvote!' do

    describe 'if user already liked' do
      it 'should return nothing' do
        expect(described_model.upvote!(user)).to be_nil
      end
    end

    describe 'if user still not liked' do

      describe 'but have dislike vote' do
        before { described_model.upvote!(user2) }

        it 'should change value of vote' do
          expect(vote2.reload.value).to eql(1)
        end
      end

      describe 'and do not have vote' do
        it 'should create new vote with positive value' do
          expect { described_model.upvote!(user3) }.to change(described_model.votes, :count).by(1)
          expect(described_model.votes.last.value).to be > 0
        end
      end
    end

  end

  describe 'Votable#downvote!' do

    describe 'if user already disliked' do
      it 'should return nothing' do
        expect(described_model.downvote!(user2)).to be_nil
      end
    end

    describe 'if user still not disliked' do

      describe 'but have like vote' do
        before { described_model.downvote!(user) }

        it 'should change value of vote' do
          expect(vote2.reload.value).to eql(-1)
        end
      end

      describe 'and do not have vote' do
        it 'should create new vote with negative value' do
          expect { described_model.downvote!(user3) }.to change(described_model.votes, :count).by(1)
          expect(described_model.votes.last.value).to be < 0
        end
      end
    end

  end

  describe 'Votable#liked_by?' do
    it 'should return true if user liked' do
      expect(described_model).to be_liked_by(user)
    end
  end

  describe 'Votable#disliked_by?' do
    it 'should return true if user disliked' do
      expect(described_model).to be_disliked_by(user2)
    end
  end

  describe 'Votable#rating' do
    it 'should return sum of votes values' do
      expect(described_model.rating).to eql(vote.value + vote2.value)
    end
  end
end
