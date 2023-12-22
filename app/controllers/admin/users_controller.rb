class Admin::UsersController < ApplicationController

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @favorite_posts = Post.includes(:user, :prefecture, :tags, :favorites, :comments).where(favorites: { user_id: @user.id })
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー情報を更新しました"
    else
      @user = User.find(params[:id])
      flash.now[:alert] = "ユーザー情報の編集に失敗しました"
      render 'edit'
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email, :is_active)
  end

end
