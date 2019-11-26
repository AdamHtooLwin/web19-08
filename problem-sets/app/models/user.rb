class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :messages

  def ban
    if self.is_banned
      self.is_banned = false
    else
      self.is_banned = true
    end

    self.save
  end
end
