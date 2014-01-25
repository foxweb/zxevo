class AddOptionsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :comments_on, :boolean, default: :true
    add_column :pages, :is_visible, :boolean, default: :true
  end
end
