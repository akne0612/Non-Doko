class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user
  before_action :authorize_owner!, only: [:edit, :update]

  def show
    @posts = @user.posts.order(created_at: :desc)
  end
  
  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "プロフィールを更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  private

  def set_user
    id = params[:id].to_s
    if id.match?(/\A\d+\z/)           # /users/1 のように数値IDなら
      @user = User.find(id)
    else                               # /users/akane のようにスラッグなら
      @user = User.find_by!(name: id)
    end
  end

  def authorize_owner!
    redirect_to @user, alert: "権限がありません。" unless user_signed_in? && current_user == @user
  end

  def user_params
    params.require(:user).permit(:name, :avatar, :bio)
  end
end
