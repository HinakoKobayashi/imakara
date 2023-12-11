class User::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
    @users = User.all
    @tags = Post.tag_counts_on(:tags).most_used(20)
  end

  def new
    @post = Post.new
    @user = current_user
  end

  def create
    params[:post][:prefecture_id] = params[:post][:prefecture_id] .to_i
    @post = Post.new(post_params)
    @user = current_user
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿を作成しました"
      @posts = Post.all
      redirect_to posts_path
    else
      flash.now[:alert] = "投稿の作成に失敗しました"
      logger.error("Failed to save post. Errors: #{@post.errors.full_messages}")
      render 'new'
    end
  end

  def show
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
    @prefecture = @post.prefecture
    @tags = @post.tag_counts_on(:tags)
  end

  def edit
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿内容を更新しました"
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "投稿内容の更新に失敗しました"
      render 'edit'
    end
  end


  private

  def post_params
     params.require(:post).permit(:prefecture_id, :tag_list, :content, :post_status, :address, :latitude, :longitude)
  end
end
