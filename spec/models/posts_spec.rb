require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    context '公開時' do
      let(:post) { build(:post, post_status: :publicized) }

      it 'contentが空欄の場合、無効である' do
        post.content = ''
        is_expected.to eq false
      end

      it 'contentが1400文字以内であること' do
        post.content = Faker::Lorem.characters(number: 1401)
        is_expected.to eq false
      end

      it 'imageが空欄の場合、無効である' do
        post.image = nil
        is_expected.to eq false
      end

      it 'tag_listが空欄の場合、無効である' do
        post.tag_list = nil
        is_expected.to eq false
      end

      it 'prefecture_idが空欄の場合、無効である' do
        post.prefecture_id = nil
        is_expected.to eq false
      end
    end

    context '下書き時' do
      let(:post) { build(:post, post_status: :draft) }

      it 'contentが空欄でも有効である' do
        post.content = ''
        is_expected.to eq true
      end

      it 'imageが空欄でも有効である' do
        post.image = nil
        is_expected.to eq true
      end

      it 'tag_listが空欄でも有効である' do
        post.tag_list = nil
        is_expected.to eq true
      end

      it 'prefecture_idが空欄でも有効である' do
        post.prefecture_id = nil
        is_expected.to eq true
      end
    end
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Prefectureモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:prefecture).macro).to eq :belongs_to
      end
    end

    context 'Commentsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context 'Favoritesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end
