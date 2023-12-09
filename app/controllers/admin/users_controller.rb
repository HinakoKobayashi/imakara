class Admin::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
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
      flash.now[:alert] = "登録情報の編集に失敗しました"
      render 'edit'
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email, :is_active)
  end

end
