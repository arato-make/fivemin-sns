class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :tag_id
      t.text :content

      t.timestamps
    end
  end
end
