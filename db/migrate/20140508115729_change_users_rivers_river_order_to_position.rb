class ChangeUsersRiversRiverOrderToPosition < ActiveRecord::Migration
  def change
    rename_column :users_rivers, :river_order, :position
  end
end
