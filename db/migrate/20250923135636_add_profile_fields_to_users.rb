class AddProfileFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :display_name, :string
    add_column :users, :username, :string
    add_column :users, :bio, :text
    add_column :users, :location, :string
    add_column :users, :website, :string
  end
end
