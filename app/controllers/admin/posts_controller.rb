class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all.includes(:tags).order(created_at: :desc)
    @users = User.all
  end

  def show
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
    @prefecture = @post.prefecture
    @tags = @post.tag_counts_on(:tags)
    @comments = @post.comments.all
    @comment = Comment.new
  end
end
