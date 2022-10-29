require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  def log_in
    FactoryBot.create(:user, name: 'test_user', email: 'test1@ex.com', password: 'password', password_confirmation: 'password', admin: false)
    visit new_session_path
    fill_in "session[email]",	with: "test1@ex.com" 
    fill_in "session[password]",	with: "password" 
    click_on 'create-session'
  end

  def admin_log_in
    FactoryBot.create(:user, name: 'admin_user', email: 'admin@ex.com', password: 'password', password_confirmation: 'password', admin: true)
    visit new_session_path
    fill_in "session[email]",	with: "admin@ex.com" 
    fill_in "session[password]",	with: "password" 
    click_on 'create-session'
  end

  describe '登録機能' do
    context 'ユーザを登録した場合' do
      before do
        visit new_user_path
        fill_in "user[name]",	with: "aki" 
        fill_in "user[email]",	with: "aki@ex.com" 
        fill_in "user[password]",	with: "password" 
        fill_in "user[password_confirmation]",	with: "password" 
        click_on '登録する'
      end

      it 'タスク一覧画面に遷移する' do
        expect(current_path).to eq '/tasks'
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      before { visit tasks_path }

      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        expect(current_path).to eq '/sessions/new'
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    context '登録済みのユーザでログインした場合' do
      let!(:other_user) { FactoryBot.create(:user) }
      before { log_in }

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(current_path).to eq '/tasks'
        expect(page).to have_content 'ログインしました'
      end

      it '自分の詳細画面にアクセスできる' do
        click_on 'アカウント詳細'
        expect(page).to have_content 'アカウント詳細ページ'
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(other_user)
        expect(current_path).to eq '/tasks'
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    let!(:other_user) { FactoryBot.create(:user, name: 'aki', email: 'test2@ex.com') }

    context '管理者がログインした場合' do
      before { admin_log_in }

      it 'ユーザ一覧画面にアクセスできる' do
        click_on 'ユーザ一覧'
        expect(page).to have_content 'ユーザ一覧ページ'
      end
  
      it '管理者を登録できる' do
        click_on 'ユーザを追加する'
        fill_in "user[name]",	with: "aki" 
        fill_in "user[email]",	with: "aki@ex.com" 
        fill_in "user[password]",	with: "password" 
        fill_in "user[password_confirmation]",	with: "password" 
        click_on '登録する'

        expect(page).to have_content 'ユーザを登録しました' 
        expect(page).to have_content 'aki'
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(other_user)
        expect(page).to have_content 'ユーザ詳細ページ' 
        expect(page).to have_content 'aki' 
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(other_user)
        expect(page).to have_content 'ユーザ編集ページ' 
        fill_in "user[email]",	with: "testttt@ex.com"
        fill_in "user[password]",	with: "password" 
        fill_in "user[password_confirmation]",	with: "password" 
        click_on '更新する'

        expect(page).to have_content 'testttt@ex.com'
      end

      it 'ユーザを削除できる' do
        click_on 'ユーザ一覧'
        accept_alert do
          click_on '削除', match: :first
        end 
        
        expect(page).to have_content '削除しました'
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before { log_in }

      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_content '管理者以外はアクセスできません'
      end
    end
  end
end