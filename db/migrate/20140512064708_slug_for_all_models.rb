class SlugForAllModels < ActiveRecord::Migration
  def change
    add_column :pages, :slug, :string, unique: true
    add_column :posts, :slug, :string, unique: true
    add_column :rivers, :slug, :string, unique: true
    add_column :states, :slug, :string, unique: true
  end
end
