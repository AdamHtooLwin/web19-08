class Need < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :item
end
