class AddRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :slug, unique: true, index: true
      t.integer :views, default: 0
      t.timestamps
    end

    create_table :regions_rivers do |t|
      t.belongs_to :region
      t.belongs_to :river
    end

    add_column :rivers, :region_id, :integer
  end
end
