class AddOptionsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :comments_on, :boolean, default: 1
    add_column :pages, :is_visible,  :boolean, default: 1
  end
end
