class User::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
    @users = User.all
  end

  def new
    @post = Post.new
    @user = current_user
  end

  def create
    @post = Post.new(post_params)
    @user = current_user
    if @post.save
      flash[:notice] = "投稿を作成しました"
      @posts = Post.all
      redirect_to user_posts_path
    else
      flash.now[:alert] = "投稿の作成に失敗しました"
      render 'new'
    end
  end

  def show
    @post = Post.with_attached_image.find(params[:id])
    @user = User.with_attached_profile_image.find(params[:id])
  end

  def edit
    @post = Post.with_attached_image.find(params[:id])
    @user = User.with_attached_profile_image.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = ""
      redirect_to user_item_path(@post)
    else
      flash.now[:alert] = "投稿内容の更新に失敗しました"
      render 'edit'
    end
  end


  private

  def post_params
     params.require(:post).permit(:user_id, :prefecture_id, :name, :content, :post_status, :address, :latitude, :longitude, :tag_id)
  end
end
