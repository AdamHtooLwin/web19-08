class Item < ApplicationRecord
  validates_uniqueness_of :name
  has_many :needs, dependent: :nullify
end
