class User < ApplicationRecord
  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  has_many :rewards
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :facebook]

  def author_of?(record)
    self.id == record.author_id
  end
end
