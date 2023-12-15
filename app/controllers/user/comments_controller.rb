class User::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    @comment.save
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy if comment
  end


  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
