require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    # テスト開始前にroot_pathを開いておく
    before do
      visit root_path
    end

    # root_pathの表示内容のテスト
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ログインボタンがある' do
        # top ページにある aタグを全て取得し、配列を確認
        log_in_link = find_all('a')[5].native.inner_text
        expect(log_in_link).to match(/Log In/)
      end
      it 'Log Inリンクの内容が正しい' do
        expect(page).to have_link 'ログイン', href: new_user_session_path
      end
      it '新規登録ボタンがある' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(sign_up_link).to match(/Sign Up/)
      end
      it 'Sign Upリンクの内容が正しい' do
        expect(page).to have_link '新規登録', href: new_user_registration_path
      end
    end
  end

  describe 'ハンバーガーメニューのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'Homeリンクが表示される: 上から1番目のリンクが「Home」である' do
        expect(find_all('a')[1].text).to eq 'Home'
      end
      it 'Postsリンクが表示される: 上から2番目のリンクが「Posts」である' do
        expect(find_all('a')[2].text).to eq 'Posts'
      end
      it 'Usersリンクが表示される: 上から3番目のリンクが「Users」である' do
        expect(find_all('a')[3].text).to eq 'Users'
      end
      it 'Sign Upリンクが表示される: 上から4番目のリンクが「Sign Up」である' do
        expect(find_all('a')[4].text).to eq 'Sign Up'
      end
      it 'Log Inリンクが表示される: 上から5番目のリンクが「Log In」である' do
        expect(find_all('a')[5].text).to eq 'Log In'
      end
      it 'Guestリンクが表示される: 上から6番目のリンクが「Guest(体験)」である' do
        expect(find_all('a')[6].text).to eq 'Guest(体験)'
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Homeを押すと、トップ画面に遷移する' do
        click_link 'Home'
        is_expected.to eq '/'
      end
      it 'Postsを押すと、投稿一覧画面に遷移する' do
        click_link 'Posts'
        is_expected.to eq '/posts'
      end
      it 'Usersを押すと、ユーザー一覧画面に遷移する' do
        click_link 'Users'
        is_expected.to eq '/users'
      end
      it 'Sign Upを押すと、新規登録画面に遷移する' do
        click_link 'Sign Up'
        is_expected.to eq '/users/sign_up'
      end
      it 'Log Inを押すと、ログイン画面に遷移する' do
        click_link 'Log In'
        is_expected.to eq '/users/sign_in'
      end
      it 'Guest(体験)を押すと、トップ画面に遷移する' do
        click_link 'Guest(体験)'
        is_expected.to eq '/'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規ユーザー登録」と表示される' do
        expect(page).to have_content '新規ユーザー登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      # ユーザー数の増減が正しく反映されるか
      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      # 画面遷移が正しくできているか
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ハンバーガーメニューのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ハンバーガーメニューの表示を確認' do
      it 'Homeリンクが表示される: 上から1番目のリンクが「Home」である' do
        home_link = find_all('a')[1].text.strip
        expect(home_link).to eq 'Home'
      end
      it 'Postsリンクが表示される: 上から2番目のリンクが「Posts」である' do
        posts_link = find_all('a')[2].text.strip
        expect(posts_link).to eq 'Posts'
      end
      it 'Usersリンクが表示される: 上から3番目のリンクが「Users」である' do
        users_link = find_all('a')[3].text.strip
        expect(users_link).to eq 'Users'
      end
      it 'My Pageリンクが表示される: 上から4番目のリンクが「My Page」である' do
        mypage_link = find_all('a')[4].native.inner_text
        expect(mypage_link).to match(/My Page/)
      end
      it 'Notificationリンクが表示される: 上から5番目のリンクが「Notification」である' do
        notification_link = find_all('a')[5].native.inner_text
        expect(notification_link).to match(/Notification/)
      end
      it 'Log Outリンクが表示される: 上から6番目のリンクが「Log Out」である' do
        logout_link = find_all('a')[6].native.inner_text
        expect(logout_link).to match(/Log Out/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[5].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        click_link 'Log Out'
        expect(current_path).to eq '/'
      end
    end
  end
end
