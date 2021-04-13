class User < ActiveRecord::Base
  validates_uniqueness_of :username, case_sensitive: false, message: 'was already taken.'
  validates_length_of     :username, :within => 3..16, allow_blank: false

  has_many :sent_messages, foreign_key: "from_user_id", class_name: "Message", dependent: :destroy
  has_many :received_messages, foreign_key: "to_user_id", class_name: "Message", dependent: :destroy
end