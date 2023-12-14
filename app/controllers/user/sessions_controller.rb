# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController

  before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  def after_sign_in_path_for(resource)
    flash[:notice] = "Matsuricationへようこそ"
      root_path
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :alert, :signed_out if signed_out
    redirect_to root_path
  end

  def guest_sign_in
    # guestメソッドはモデルで定義
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "ゲストユーザーでログインしました。"
  end


  private

  def user_state
   #puts "Params: #{params.inspect}"
   user = User.find_by(email: params[:user][:email])
   if user.nil?
     return
   end
   unless user.valid_password?(params[:user][:password])
     return
   end
   unless user.is_active == true
     flash[:alert] = "すでに退会しています。"
      redirect_to new_user_registration_path
   end
  end


  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
end
