class AddRiverCity < ActiveRecord::Migration
  def change
    add_column :rivers, :city, :string
  end
end
