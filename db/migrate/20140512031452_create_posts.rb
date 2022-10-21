class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :status, default: "published"
      t.string :meta_keywords
      t.string :meta_description

      t.timestamps
    end
  end
end
