require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  let(:user) { build(:user) }

  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
    subject { user.valid? }

    context 'nameカラム' do
      it '空欄でないこと' do
      user.name = ''
      is_expected.to eq false
      end
    end

    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        is_expected.to eq false
      end

      it '一意であること' do
        user.save
        another_user = build(:user, email: user.email)
        another_user.valid?
        expect(another_user.errors[:email]).to include("has already been taken")
      end
    end

    context 'passwordカラム' do
      it '作成時に空欄でないこと' do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end

      it '最小文字数が6文字であること' do
        user.password = '12345'
        user.valid?
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end

  describe 'メソッドのテスト' do
    context '#get_profile_image' do
      it 'プロフィール画像が設定されていれば、その画像を返す' do
        user.profile_image.attach(io: File.open(Rails.root.join('spec/fixtures/sample_profile_image.jpg')),
                                  filename: 'sample_profile_image.jpg', content_type: 'image/jpeg')
        expect(user.get_profile_image(300, 300)).to be_a(ActiveStorage::Variant)
      end
    end
    it 'プロフィール画像が設定されていなければ、デフォルト画像を返す' do
      expect(user.get_profile_image(300, 300)).to eq ActionController::Base.helpers.asset_path('no_image.jpg')
    end
  end

  context '.guest_user' do
    it 'ゲストユーザーを返す' do
      guest_user = User.guest_user
      expect(guest_user.email).to eq User::GUEST_USER_EMAIL
      expect(guest_user.name).to eq "guestuser"
    end
  end

  context '#guest_user?' do
    it 'ゲストユーザーかどうかを判定する' do
      guest_user = User.guest_user
      expect(guest_user.guest_user?).to be true

      normal_user = create(:user)
      expect(normal_user.guest_user?).to be false
    end
  end
end
