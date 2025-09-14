class ShopsController < ApplicationController

  before_action :set_genres

  def index
    @center_lat, @center_lng = resolve_center(params[:place], params[:lat], params[:lng])
    @radius_km = params[:radius_km].presence&.to_f

    @posts = Post
      .with_attached_image  
      .includes(:genre, :user)
      .by_keyword(params[:q])
      .by_genre(params[:genre_id])
      .within_radius(@center_lat, @center_lng, @radius_km)
      .order_by_distance_from(@center_lat, @center_lng)
      .order(created_at: :desc)

   
  end

  private

  def set_genres
    @genres = Genre.order(:name)
  end

  # place（地名/駅/住所）→ lat/lng を決める
  def resolve_center(place, lat, lng)
    # 1) 既に座標が来ていればそれを使用（現在地ボタン）
    return [lat, lng] if lat.present? && lng.present?

    # 2) place が入力されていればジオコーディング
    if place.present?
      if (g = Geocoder.search(place).first)
        return [g.latitude, g.longitude]
      end
    end

    # 3) どちらも無ければ nil（全件表示、距離ソート無し）
    [nil, nil]
  end
end
  
