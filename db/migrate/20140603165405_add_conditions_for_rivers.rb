class AddConditionsForRivers < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION hstore'
    add_column :rivers, :conditions, :hstore
  end
end
