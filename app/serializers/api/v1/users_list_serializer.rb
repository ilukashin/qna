class Api::V1::UsersListSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at
end
