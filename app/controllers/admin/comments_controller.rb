class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = Comment.includes(:user, :post).order(created_at: :desc)
   
  end

  def destroy
    Comment.find(params[:id]).destroy!
    redirect_to admin_comments_path, notice: "コメントを削除しました。"
  end
end
