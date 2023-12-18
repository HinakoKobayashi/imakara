class User::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.published.all.includes(:tags).order(created_at: :desc)
    @users = User.all
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @user = current_user
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.published?
      # 公開処理
      if @post.save
        redirect_to posts_path, notice: "投稿を公開しました！"
      else
        render :new, alert: "投稿の公開に失敗しました。"
      end
    else
      # 下書き保存処理
      if @post.save
        redirect_to user_path(current_user), notice: "下書きを保存しました！"
      else
        render :new, alert: "下書きの保存に失敗しました。"
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
      @post.draft!
      notice_message = "下書きを保存しました"
      redirect_path = user_path(current_user)
    elsif params[:unpublished].present?
      @post.unpublished!
      notice_message = "非公開にしました"
      redirect_path = user_path(current_user)
    else
      @post.published!
      notice_message = "投稿内容を更新しました"
      redirect_path = post_path(@post)
    end

    if @post.update(post_params)
      flash[:notice] = "投稿内容を更新しました"
      redirect_to redirect_path, notice: notice_message
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
     params.require(:post).permit(:image, :prefecture_id, :tag_list, :content, :post_status, :address, :latitude, :longitude)
  end
end
