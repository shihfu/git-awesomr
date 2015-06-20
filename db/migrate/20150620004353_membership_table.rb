class MembershipTable < ActiveRecord::Migration
  def change
     create_table :membership do |t|
      t.references :user
      t.references :group
      t.timestamps null: false
    end
  end
end
