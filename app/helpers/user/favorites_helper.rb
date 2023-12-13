module User::FavoritesHelper
  def favorited_by?(user, post)
    return false unless user
    post.favorites.exists?(user_id: user.id)
  end
end
