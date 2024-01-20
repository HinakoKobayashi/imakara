require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト', type: :system do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end



  describe 'ハンバーガーメニューのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済み' do
      subject { current_path }

      it 'Homeを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[1].text.strip
        click_link home_link
        is_expected.to eq '/'
      end
      it 'Postsを押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[2].text.strip
        click_link posts_link
        is_expected.to eq '/posts'
      end
      it 'Usersを押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[3].text.strip
        click_link users_link
        is_expected.to eq '/users'
      end
      it 'My Pageを押すと、ユーザー詳細画面に遷移する' do
        mypage_link = find_all('a')[4].text.strip
        click_link mypage_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Notificationを押すと、通知一覧画面に遷移する' do
        notification_link = find_all('a')[5].text.strip
        click_link notification_link
        expect(current_path).to match(/^\/notifications/)
      end
      it 'Log Outを押すと、トップ画面に遷移する' do
        logout_link = find_all('a')[6].text.strip
        click_link logout_link
        is_expected.to eq '/'
      end
    end
  end

  describe '投稿作成モーダルのテスト' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit root_path # または投稿ボタンが存在する任意のページ
    end

    it '投稿モーダルが正しく表示される' do
      # 投稿ボタンをクリック
      find('.button-text').click
      expect(page).to have_css('#newPostModal', visible: true)

      # モーダル内の要素を確認
      within('#newPostModal') do
        expect(page).to have_field 'post[content]'
        expect(page).to have_field 'post[image]'
        expect(page).to have_field 'post[prefecture_id]'
        expect(page).to have_field 'post[tag_list]'
        expect(page).to have_button '公開'
        expect(page).to have_button '下書き保存'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it '投稿の内容が正しく表示されている' do
      expect(page).to have_content(post.content)
      expect(page).to have_selector("img[src*='no_image.jpg']")
      expect(page).to have_content(post.prefecture.name)
      post.tags.each do |tag|
        expect(page).to have_content(tag.name)
      end
    end
  end

  describe '投稿作成' do
    before do
      visit posts_path
    end

    context '公開時' do
      it '必要な情報を入力すると、投稿が成功する' do
        fill_in 'new_post_content', with: 'テスト投稿'
        attach_file 'new_post_image', 'spec/fixtures/no_image.jpg'
        fill_in 'new_post_tag', with: 'タグ1, タグ2'
        select '東京都', from: 'new_post_prefecture'
        click_button 'new_post_submit'
        expect(page).to have_content('投稿を公開しました')
      end
    end

    context '下書き時' do
      it '情報が不足していても、下書き保存が成功する' do
        fill_in 'new_post_content', with: ''
        click_button 'draft_post_submit'
        expect(page).to have_content('下書きを保存しました')
      end
    end
  end
end

  context '投稿成功のテスト' do
    it '自分の新しい投稿が正しく保存される' do
      fill_in 'new_post_content', with: Faker::Lorem.characters(number: 20)
      attach_file 'new_post_image', 'spec/fixtures/no_image.jpg'
      fill_in 'new_post_tag', with: 'タグ1, タグ2'
      select '東京都', from: 'new_post_prefecture'
      expect {
        click_button 'new_post_submit'
        user.reload
      }.to change(user.posts, :count).by(1)
    end
  end


  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it 'ユーザー情報が正しく表示される' do
        # 自分の情報が表示されていることを確認
        within("tr[onclick='window.location=\"#{user_path(user)}\"']") do
          expect(page).to have_selector("img[src*='animal_mark_hiyoko.png']")
          expect(page).to have_text(user.name)
          expect(page).to have_text(user.introduction)
        end

        # 他のユーザーの情報が表示されていることを確認
        within("tr[onclick='window.location=\"#{user_path(other_user)}\"']") do
          expect(page).to have_selector("img[src*='animal_mark_hiyoko.png']")
          expect(page).to have_text(other_user.name)
          expect(page).to have_text(other_user.introduction)
        end
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧に自分の投稿が表示される' do
        expect(page).to have_content(post.content)
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(find_field('user[introduction]').text).to be_blank
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        expect(user.profile_image).to be_attached
        click_button '更新'
        save_page
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end