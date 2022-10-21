class AddViewsToRivers < ActiveRecord::Migration
  def change
    add_column :rivers, :views, :integer, default: 0
  end
end
