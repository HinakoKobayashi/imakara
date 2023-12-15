class SearchesController < ApplicationController
  def index
    @keyword = params[:keyword]
    @search_type = params[:search_type]

    if @keyword.present?
      keyword_pattern = "%#{@keyword}%"
      # contentでの検索
      @posts_by_content = Post.where("content LIKE ?", keyword_pattern)
      # タグ名での検索
      @posts_by_tag = Post.tagged_with(@keyword)
      # 県名での検索
      @posts_by_prefecture = Post.joins(:prefecture).where("prefectures.name = ?", @keyword)
      # 両方のクエリから投稿を取得し、重複を除去する
      @posts = (@posts_by_content + @posts_by_tag + @posts_by_prefecture).uniq
      # ユーザー検索
      @users = User.where("name LIKE :keyword OR introduction LIKE :keyword", keyword: keyword_pattern)
    else
      @posts = Post.none
      @users = User.none
    end
  end
end
