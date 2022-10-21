class AddRadarImageToStates < ActiveRecord::Migration
  def change
    add_column :states, :radar_image, :string
  end
end
