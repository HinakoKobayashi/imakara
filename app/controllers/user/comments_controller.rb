class User::CommentsController < ApplicationController
  before_action :authenticate_user!, unless: :guest_user?

  def create
    @post = Post.find(params[:post_id])
    @user = guest_user? ? User.guest_user : current_user
    @comment = @user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      respond_to do |format|
        format.js
      end
    end
  end

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

  def guest_user?
    user_signed_in? && current_user.guest_user?
  end

end
