class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to post_path(@post), notice: "コメントを追加しました。"
    else
      @comments = @post.comments.includes(:user).order(created_at: :asc)
      flash.now[:alert] = "コメントを追加できませんでした。"
      render "posts/show"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.user_id == current_user.id || (defined?(admin_signed_in?) && admin_signed_in?)
      @comment.destroy
      redirect_to post_path(@post), notice: "コメントを削除しました。"
    else
      redirect_to post_path(@post), alert: "削除権限がありません。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end