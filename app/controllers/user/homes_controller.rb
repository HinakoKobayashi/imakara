class User::HomesController < ApplicationController
  def top
    @user = current_user
    @request = Request.new
  end

end
