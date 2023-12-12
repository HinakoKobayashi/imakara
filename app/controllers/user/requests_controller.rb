class User::RequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @request = Request.new
    @user = current_user
  end

  def create
    @request = Request.new(request_params)
    @user = current_user
    @request.user_id = current_user.id
    if @request.save
      flash[:notice] = "リクエストを送信しました"
      redirect_to request.referer
    else
      flash.now[:alert] = "リクエストの送信に失敗しました"
      render 'new'
    end
  end


  private

  def request_params
    params.reqire(:request).permit(:title, :body)
  end
end
