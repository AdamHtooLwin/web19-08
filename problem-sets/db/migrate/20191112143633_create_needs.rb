class CreateNeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :needs do |t|
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.decimal :quantity

      t.timestamps
    end
  end
end
