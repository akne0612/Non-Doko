class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true   # ← いいね数を自動カウント
  validates :user_id, uniqueness: { scope: :post_id }
end
