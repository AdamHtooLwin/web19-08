class Group < ApplicationRecord
  belongs_to :user
  has_many :comments

  has_many :user_groups
  has_many :users, through: :user_groups
end
