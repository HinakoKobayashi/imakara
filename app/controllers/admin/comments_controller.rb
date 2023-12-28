class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment
      @post = @comment.post
      @comment.destroy
      respond_to do |format|
        format.js
      end
    else
      head :not_found
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
