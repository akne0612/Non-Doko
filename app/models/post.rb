class Post < ApplicationRecord
 
    belongs_to :user
    belongs_to :genre
  
    validates :title, presence: true
    validates :body,  presence: true
    validates :genre_id, presence: true
  
    has_one_attached :image
    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes, source: :user
    has_many :comments, dependent: :destroy
  
    # 住所 → 緯度経度
    geocoded_by :address
    after_validation :geocode, if: -> { will_save_change_to_address? && address.present? }
  
    # キーワード（部分一致）
    scope :by_keyword, ->(q) do
      if q.present?
        esc = sanitize_sql_like(q)
        where("posts.title LIKE :q OR posts.body LIKE :q", q: "%#{esc}%")
      else
        all
      end
    end
  
    # ジャンル
    scope :by_genre, ->(gid) do
      gid.present? ? where(genre_id: gid) : all
    end
  
    # 半径kmで絞り込み（半径未指定なら全件返す）
    scope :within_radius, ->(lat, lng, km = nil) do
      if lat.present? && lng.present? && km.present?
        lat_f = lat.to_f
        lng_f = lng.to_f
        km_f  = km.to_f
  
        # 緯度1度 ≈ 111.045km
        dlat = km_f / 111.045
        # 経度方向は緯度によって縮む（SQLiteに三角関数を渡さない）
        cos = Math.cos(lat_f * Math::PI / 180.0)
        dlng = km_f / (111.045 * (cos.zero? ? 1.0 : cos).abs)
  
        where(latitude:  (lat_f - dlat)..(lat_f + dlat))
          .where(longitude: (lng_f - dlng)..(lng_f + dlng))
      else
        all
      end
    end
  
    # SQLite では距離ソートは無効化（半径絞り込みのみ）
    scope :order_by_distance_from, ->(_lat, _lng) do
      all
    end
  
    # 本番(MySQL/PG)向けの距離式（SQLiteでは未使用）
    def self.distance_sql(lat, lng, tbl = table_name)
      lat = lat.to_f
      lng = lng.to_f
      <<~SQL.squish
        (6371 * acos(
          cos(radians(#{lat})) * cos(radians(COALESCE(#{tbl}.latitude, 0))) *
          cos(radians(COALESCE(#{tbl}.longitude, 0)) - radians(#{lng})) +
          sin(radians(#{lat})) * sin(radians(COALESCE(#{tbl}.latitude, 0)))
        ))
      SQL
    end
  
    # 便利
    def liked_by?(user)
      return false unless user
      likes.exists?(user_id: user.id)
    end
  end