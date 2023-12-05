class Post < ApplicationRecord

  enum post_status: { published: 0, draft: 1, unpublished: 2 }

  validates :post_status, presence: true

end
