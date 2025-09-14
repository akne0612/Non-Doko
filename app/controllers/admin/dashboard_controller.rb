class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users_count    = User.count
    @posts_count    = Post.count
    @genres_count   = Genre.count
    @comments_count = Comment.count if defined?(Comment)
    @latest_posts   = Post.order(created_at: :desc).limit(5)
end
end