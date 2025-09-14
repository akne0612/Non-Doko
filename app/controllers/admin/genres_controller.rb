class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.order(:name)
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to admin_genres_path, notice: "ジャンルを追加しました。"
    else
      flash.now[:alert] = "追加に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path, notice: "ジャンルを更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    if @genre.destroy
      redirect_to admin_genres_path, notice: "ジャンルを削除しました。"
    else
     
      redirect_to admin_genres_path, alert: @genre.errors.full_messages.to_sentence.presence || "このジャンルは使用中のため削除できません。"
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end