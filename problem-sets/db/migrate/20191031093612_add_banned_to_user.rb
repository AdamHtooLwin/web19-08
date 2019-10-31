class AddBannedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_banned, :boolean
  end
end
