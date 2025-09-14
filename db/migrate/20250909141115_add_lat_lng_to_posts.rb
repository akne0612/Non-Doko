class AddLatLngToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :latitude,  :decimal, precision: 10, scale: 6 unless column_exists?(:posts, :latitude)
    add_column :posts, :longitude, :decimal, precision: 10, scale: 6 unless column_exists?(:posts, :longitude)

    add_index :posts, [:latitude, :longitude] unless index_exists?(:posts, [:latitude, :longitude])
  end
end
