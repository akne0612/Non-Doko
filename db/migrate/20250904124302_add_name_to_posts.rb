class AddNameToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :name, :string, null: false
    add_index :posts, :name 
  end
end
