class HomesController < ApplicationController
  def top
    @posts = Post.order(created_at: :desc).limit(3)  # ← ここで用意
  end
   

  def about
  end
end
