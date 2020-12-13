class Comment < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true

  settings do
    mappings dynamic: false do
      indexes :body, type: :text
    end
  end
end
