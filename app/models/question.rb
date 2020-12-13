class Question < ApplicationRecord
  include Votable
  include Commentable
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  settings do
    mappings dynamic: false do
      indexes :title, type: :text
      indexes :body, type: :text
    end
  end
end
