class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:my]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    @genres = Genre.all
  end

  def create
    @post = current_user.posts.new(post_params)
    @genres = Genre.all
    if @post.save
      redirect_to @post, notice: '投稿が完了しました。'
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @genres = Genre.all
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿を削除しました。'
  end

 def my
  @posts = current_user.posts.includes(:genre).order(created_at: :desc)
 end

 def search
  if params[:query].present?
    @posts = Post.where("title LIKE ?", "%#{params[:query]}%")
  else
    @posts = Post.all
  end
  render :index
 end
  
  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to posts_path, alert: '権限がありません' unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:genre_id, :title, :body, :name, :address, :latitude, :longitude, :image, :store_name)
  end
end

