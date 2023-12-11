class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all
    @users = User.all
    #@tags = @post.tag_counts_on(:tags)
  end

  def show
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
    # @prefecture = @post.prefecture
    @tags = @post.tag_counts_on(:tags)
  end
end
