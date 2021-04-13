class Message < ActiveRecord::Base
  belongs_to            :from_user, class_name: :User
  belongs_to            :to_user, class_name: :User

  validates_length_of   :content, within: 1..1000, allow_blank: false
end