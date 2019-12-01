class Group < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

  has_many :needs, dependent: :destroy
end
