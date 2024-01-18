require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  let!(:user) { create(:user) } # build から create に変更して、user をデータベースに保存
  let!(:other_user) { create(:user) }

  describe 'バリデーションのテスト' do
    # テスト用使い捨てデータ作成
    # build は new メソッドのような役割
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
        # エラー文に含まれる文字列を判定
        expect(another_user.errors[:email]).to include("入力されたメールアドレスはすでに存在します")
      end
    end

    context 'passwordカラム' do
      it '作成時に空欄でないこと' do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("を入力してください")
      end

      it '最小文字数が6文字であること' do
        user.password = '12345'
        user.valid?
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    let(:user) { build(:user) }
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context 'Requestモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:requests).macro).to eq :has_many
      end
    end
    # notiificationは送信と受信でclass_nameとforeign_keyを考慮して作成
    context 'Notificationモデルとの関係' do
      context '送信された通知（sent_notifications）' do
        it '1:Nとなっている' do
          expect(User.reflect_on_association(:sent_notifications).macro).to eq :has_many
          expect(User.reflect_on_association(:sent_notifications).class_name).to eq 'Notification'
          expect(User.reflect_on_association(:sent_notifications).foreign_key).to eq 'visitor_id'
        end
      end

      context '受信された通知（received_notifications）' do
        it '1:Nとなっている' do
          expect(User.reflect_on_association(:received_notifications).macro).to eq :has_many
          expect(User.reflect_on_association(:received_notifications).class_name).to eq 'Notification'
          expect(User.reflect_on_association(:received_notifications).foreign_key).to eq 'visited_id'
        end
      end
    end
  end

  describe 'メソッドのテスト' do
    # let(:user) { build(:user) }


    context '#get_profile_image' do
      it 'プロフィール画像が設定されていれば、その画像を返す' do
        user.profile_image.attach(io: File.open(Rails.root.join('spec/fixtures/animal_mark_hiyoko.png')),
                                  filename: 'animal_mark_hiyoko.png', content_type: 'image/png')
        user.save
        # クラス名に一致させる be_a 要検索
        expect(user.get_profile_image(300, 300)).to be_a(ActiveStorage::VariantWithRecord)
      end
    end
    it 'プロフィール画像が設定されていなければ、デフォルト画像を返す' do
      # purge メソッドでプロフィール画像を削除
      other_user.profile_image.purge
      expect(other_user.get_profile_image(300, 300)).to eq ActionController::Base.helpers.asset_path('no_image.jpg')
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

  context '#frequently_used_tags' do
    let(:tag1) { create(:tag, name: 'タグ1') }
    let(:tag2) { create(:tag, name: 'タグ2') }

    before do
      # ユーザーの投稿とタグを設定
      post1 = create(:post, user: user)
      post1.tag_list.add("タグ1")
      post1.save

      post2 = create(:post, user: user)
      post2.tag_list.add("タグ2")
      post2.save

      post3 = create(:post, user: user)
      post3.tag_list.add("タグ1")
      post3.save
    end

    it 'ユーザーがよく使うタグを表示できているか判定する' do
      expected_tags = user.frequently_used_tags.slice('タグ1', 'タグ2')
      expect(expected_tags).to eq({ 'タグ1' => 2, 'タグ2' => 1 })
    end

    it 'もしユーザーがタグを持っていなくても true を返す' do
      expect(other_user.frequently_used_tags).to be_truthy
    end
  end
end
