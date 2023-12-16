class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all.includes(:tags).order(created_at: :desc)
    @users = User.all
  end

  def show
    @post = Post.with_attached_image.find(params[:id])
    @user = @post.user
    @prefecture = @post.prefecture
    @tags = @post.tag_counts_on(:tags)
    @comments = @post.comments.all
    respond_to do |format|
      format.html
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式で行われる（詳しくは参照記事をご覧ください）
      format.js
    end
  end
end
