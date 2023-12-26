class User::PostsController < ApplicationController
  before_action :authenticate_user!, unless: :guest_user?, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.where(post_status: :publicized).includes(:tags).order(created_at: :desc).page(params[:page]).per(12)
    @users = User.all
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @user = current_user
  end

  def create
    @user = guest_user? ? User.guest_user : current_user
    @post = @user.posts.build(post_params)

    if @post.save
      flash[:notice] = message_for_post_status(@post.post_status)
      redirect_to appropriate_redirect_path_for(@post)
    else
      flash.now[:alert] = "投稿の作成に失敗しました"
      render :new
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
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式で行われる
      format.js
    end
  end

  def edit
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
  end

  def update
    if @post.update(post_params)
      flash[:notice] = message_for_post_status(@post.post_status)
      redirect_to appropriate_redirect_path_for(@post)
    else
      flash.now[:alert] = "投稿の更新に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿が削除されました"
    redirect_to posts_path
  end


  private
  # ゲストユーザーかどうかを判断
  def guest_user?
    user_signed_in? && current_user.guest_user?
  end

  def set_user
    @user = current_user
  end

  # フォームから送信されたパラメータに基づいて投稿ステータスを設定
  def set_post
    @post = Post.with_attached_image.find_by(id: params[:id])
    redirect_to(posts_path, alert: "投稿が見つかりません") unless @post
  end

  def post_params
    params.require(:post).permit(:image, :prefecture_id, :tag_list, :content, :post_status)
  end

  # 処理成功後のフラッシュメッセージ設定
  def message_for_post_status(status)
    case status
    when 'draft'
      "下書きを保存しました"
    when 'unpublicized'
      "非公開にしました"
    when 'publicized'
      "投稿を公開しました"
    when 'edit'
      "投稿内容を更新しました"
    else
      "不明なステータスです"
    end
  end

  # Postのステータスが publicized の場合にのみ posts_path にリダイレクト
  # それ以外の場合（draft, unpublicized）には user_path(current_user) にリダイレクト
  def appropriate_redirect_path_for(post)
    post.publicized? ? posts_path : user_path(current_user)
  end
end
