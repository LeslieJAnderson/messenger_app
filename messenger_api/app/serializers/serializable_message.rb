class SerializableMessage < JSONAPI::Serializable::Resource
  type 'message'

  attributes :created_at

  attribute :from_username do
    User.find(@object.from_user_id).username
  end

  attribute :to_username do
    User.find(@object.to_user_id).username
  end

  attributes :content

end