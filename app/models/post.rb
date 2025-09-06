class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre

  validates :title, presence: true
  validates :body, presence: true
  validates :genre_id, presence: true
  

  has_one_attached :image
end
