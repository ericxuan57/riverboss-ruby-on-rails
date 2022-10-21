class AddAdminAndBlockedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    add_column :users, :blocked, :boolean
  end
end
