class CreateUsersRivers < ActiveRecord::Migration
  def change
    create_table :users_rivers do |t|
      t.belongs_to :river
      t.belongs_to :user
      t.integer :river_order
      t.timestamps
    end
  end
end
