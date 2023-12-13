class Admin::RequestsController < ApplicationController
  def index
    @requests = Request.all.order(created_at: :desc)
    @user = @request.user
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
