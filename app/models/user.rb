class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  has_one_attached :profile_image

  def get_profile_image(width, height)
    if profile_image.attached?
      begin
        profile_image.variant(resize_to_limit: [width, height]).processed
      rescue ActiveStorage::InvariableError
        ActionController::Base.helpers.asset_path('animal_mark_hiyoko.png')
      end
    else
      ActionController::Base.helpers.asset_path('no_image.jpg')
    end
  end

  GUEST_USER_EMAIL = "guest@example.com"

  # guestメソッド
  def self.guest_user
    # データの検索と作成を自動的に判断して処理を行うRailsのメソッド
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      # ランダムな文字列を生成するRubyのメソッド
      user.password = SecureRandom.urlsafe_base64
      # nameは"guestuser"に固定
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

end
