class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :genres, null: false, foreign_key: true
      t.string :title
      t.text :body
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :image_path

      t.timestamps
    end
  end
end
