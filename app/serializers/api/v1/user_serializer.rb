class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :created_at, :updated_at
end
