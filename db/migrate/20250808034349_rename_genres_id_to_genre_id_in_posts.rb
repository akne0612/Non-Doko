class RenameGenresIdToGenreIdInPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :genres_id, :genre_id
  end
end
