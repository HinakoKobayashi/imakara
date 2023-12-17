class User::FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    if favorite.save
      render json: { status: 'ok', message: 'いいねしました' }
    else
      render json: { status: 'error', message: 'いいねに失敗しました' }
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end
