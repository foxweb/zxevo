class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string     :title, null: false, default: ''
      t.string     :slug, unique: true, null: false, default: ''
      t.text       :body, null: false
      t.references :user, index: false

      t.timestamps
    end
    add_index :pages, :user_id
  end
end
