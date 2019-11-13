class AddUnitToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :unit, :string
  end
end
