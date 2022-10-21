class AddIndicesForTables < ActiveRecord::Migration
  def change
    add_index :rivers, [:slug, :site_no]
    add_index :states, :slug
    add_index :posts, :slug
    add_index :pages, :slug
  end
end
