class AddNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, default: '', unique: true
  end
end
