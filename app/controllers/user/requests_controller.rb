class User::RequestsController < ApplicationController
  before_action :authenticate_user!, except: :create

  def new
    @request = Request.new
    @user = current_user
  end

  def create
    @request = Request.new(request_params)
    if user_signed_in?
      @request.user_id = current_user.id
    end
    if @request.save
      flash[:notice] = "リクエストを送信しました"
      redirect_to root_path
    else
      flash.now[:alert] = "リクエストの送信に失敗しました"
      render 'new'
    end
  end


  private

  def request_params
    params.require(:request).permit(:title, :body)
  end
end
