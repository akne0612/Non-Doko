class FixIndexNameOnPosts < ActiveRecord::Migration[6.1]
  def change
    remove_index :posts, name: "index_posts_on_genres_id"
  add_index :posts, :genre_id, name: "index_posts_on_genre_id"
  end
end
