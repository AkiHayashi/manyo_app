require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user, name: 'test_user', email: 'test1@ex.com', password: 'password', password_confirmation: 'password', admin: false) }
  def log_in
    visit new_session_path
    fill_in "session[email]",	with: "test1@ex.com" 
    fill_in "session[password]",	with: "password" 
    click_on 'create-session'
  end

  describe '登録機能' do
    before { log_in }

    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in "label_name",	with: "test" 
        click_on '登録する'
        expect(page).to have_content 'ラベルを登録しました'
        expect(page).to have_content 'test'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      FactoryBot.create(:label, name: 'テスト１')
      FactoryBot.create(:label, name: 'テスト２')

      before do
        log_in
        visit labels_path
      end

      it '登録済みのラベル一覧が表示される' do
        labels_list = all('body tr')
        expect(labels_list[1].text).to have_content('テスト１')
        expect(labels_list[2].text).to have_content('テスト２')
      end
    end
  end
end
