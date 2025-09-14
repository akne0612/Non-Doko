class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!  # DeviseのAdmin認証

  def index
    @users = User.order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザーを更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy!
    redirect_to admin_users_path, notice: "ユーザーを削除しました。"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :profile)
  end
end