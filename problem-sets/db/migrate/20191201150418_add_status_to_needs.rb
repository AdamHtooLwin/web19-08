class AddStatusToNeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :needs, :status, :string
  end
end
