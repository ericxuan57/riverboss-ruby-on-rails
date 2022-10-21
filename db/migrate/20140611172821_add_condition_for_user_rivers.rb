class AddConditionForUserRivers < ActiveRecord::Migration
  def change
    add_column :users_rivers, :conditions, :hstore
  end
end
