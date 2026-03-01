class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :user, index: false

      t.timestamps
    end
    add_index :posts, :user_id
  end
end
