class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.likes.find_or_create_by!(post: @post)
    redirect_back fallback_location: post_path(@post), notice: "いいねしました。"
  end

  def destroy
    like = @post.likes.find(params[:id])
    if like.user_id == current_user.id || (defined?(admin_signed_in?) && admin_signed_in?)
      like.destroy
      redirect_back fallback_location: post_path(@post), notice: "いいねを解除しました。"
    else
      redirect_back fallback_location: post_path(@post), alert: "権限がありません。"
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end