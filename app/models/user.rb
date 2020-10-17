class User < ApplicationRecord
  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  has_many :rewards
  has_many :authorizations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  def author_of?(record)
    self.id == record.author_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token(20)
      user = User.create!(email: auth.info[:email], password: password, password_confirmation: password)
    end
    user.create_authorizatoin(auth)
    user
  end

  def create_authorizatoin(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
