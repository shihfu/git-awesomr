class GroupTable < ActiveRecord::Migration
  def change
      create_table :group do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
