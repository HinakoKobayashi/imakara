class User::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :check]
  before_action :ensure_correct_user, only: [:edit, :update, :check]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.where.not(name: 'guestuser').page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @frequently_used_tags = @user.frequently_used_tags
    @posts = @user.posts
    @publicized_posts = @user.posts.publicized.order(created_at: :desc)
    @draft_posts = @user.posts.draft
    @favorite_posts = Post.includes(:user, :prefecture, :tags, :favorites, :comments).where(favorites: { user_id: @user.id })
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました"
    else
      @user = User.find(params[:id])
      flash.now[:alert] = "ユーザー情報の編集に失敗しました"
      render 'edit'
    end
  end

  def check
  end

  def cancellation
    @user = current_user
    @user.update(is_active: false)
    sign_out(@user)
    flash[:notice] = "退会が完了しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィールを編集できません"
    end
  end

end
