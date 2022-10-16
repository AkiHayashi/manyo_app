require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "task_title",	with: "test" 
        fill_in "task_content",	with: "test content" 
        click_on '登録する'
        expect(page).to have_content 'タスクを登録しました'
        expect(page).to have_content 'test'
        expect(page).to have_content 'test content'
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_task) { FactoryBot.create(:task, title: '書類作成', content: 'テスト１', created_at: Time.zone.local(2022, 2, 18)) }
    let!(:second_task) { FactoryBot.create(:task, title: '競合調査', content: 'テスト２', created_at: Time.zone.local(2022, 2, 17)) }
    let!(:third_task) { FactoryBot.create(:task, title: 'タスク管理', content: 'テスト３', created_at: Time.zone.local(2022, 2, 16)) }

    before { visit tasks_path }

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('body tr')
        expect(task_list[1].text).to eq('書類作成 テスト１ 2022/02/18 00:00 詳細 編集 削除')
        expect(task_list[2].text).to eq('競合調査 テスト２ 2022/02/17 00:00 詳細 編集 削除')
        expect(task_list[3].text).to eq('タスク管理 テスト３ 2022/02/16 00:00 詳細 編集 削除')
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        click_on 'タスクを登録する'
        visit new_task_path
        fill_in "task_title",	with: "test" 
        fill_in "task_content",	with: "test content" 
        click_on '登録する'

        task_list = all('body tr')
        expect(task_list[1].text).to have_content('test test content')
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:second_task, title: '競合調査', content: '他社のサービスを調査する。')
        visit task_path(task)
        expect(page).to have_content '競合調査'
        expect(page).to have_content '他社のサービスを調査する。'
      end
    end
  end
end