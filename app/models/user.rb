class User < ApplicationRecord
  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(record)
    self.id == record.author_id
  end
end
