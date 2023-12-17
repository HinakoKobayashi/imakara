class User::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all.includes(:tags).order(created_at: :desc)
    @users = User.all
    @comment = Comment.new
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
    
    if params[:draft].present?
      @post.post_post_status = :draft
    else
      @post.post_post_status = :published
    end
    
    if @post.save
      if @post.draft?
        redirect_to dashboard_posts_path, notice: '下書きが保存されました'
      elsif @post.published?
        flash[:notice] = "投稿を作成しました"
        @posts = Post.all
        redirect_to posts_path
      else
        flash.now[:alert] = "投稿の作成に失敗しました"
        render 'new'
      end
    end
  end

  def show
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
    @prefecture = @post.prefecture
    @tags = @post.tag_counts_on(:tags)
    @comments = @post.comments.all
    @comment = Comment.new
    respond_to do |format|
      format.html
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式で行われる（詳しくは参照記事をご覧ください）
      format.js
    end
  end

  def edit
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
  end

  def update
    @post = Post.find(params[:id])
    
    if params[:draft].present?
      @post.post_status = :draft
      notice_message = "下書きを保存しました。"
      redirect_path = dashboard_posts_path
    elsif params[:unpublished].present?
      @post.post_status = :unpublished
      notice_message = "非公開にしました。"
      redirect_path = dashboard_posts_path
    else
      @post.post_status = :published
      notice_message = "投稿を更新しました。"
      redirect_path = post_path(@post)
    end
    
    if @post.update(post_params)
      flash[:notice] = "投稿内容を更新しました"
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "投稿内容の更新に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿が削除されました"
    redirect_to posts_path
  end

  private

  def post_params
     params.require(:post).permit(:image, :prefecture_id, :tag_list, :content, :post_post_status, :address, :latitude, :longitude)
  end
end
