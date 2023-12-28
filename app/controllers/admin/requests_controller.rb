class Admin::RequestsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @requests = Request.all.order(created_at: :desc)
    @request = @requests.first
    if @request
      @user = @request.user
    else
      flash[:alert] = "リクエストがありません"
      redirect_to root_path
    end
  end

  def show
    @request = Request.find(params[:id])
    @user = @request.user
  end

  private

  def request_params
    params.require(:request).permit(:title, :body)
  end
end
