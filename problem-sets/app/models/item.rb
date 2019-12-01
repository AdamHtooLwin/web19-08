class Item < ApplicationRecord
  validates_uniqueness_of :name
end
