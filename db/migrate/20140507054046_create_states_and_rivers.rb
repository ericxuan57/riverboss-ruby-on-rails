class CreateStatesAndRivers < ActiveRecord::Migration

  def change
    create_table :rivers do |t|
      t.string :site_no
      t.string :name
      t.string :name_short
      t.float :latitude
      t.float :longitude
      t.belongs_to :state
      t.timestamps
    end

    create_table :states do |t|
      t.string :name
      t.string :code
      t.timestamps
    end
  end

end
