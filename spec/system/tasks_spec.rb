require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "task_title",	with: "test" 
        fill_in "task_content",	with: "test content" 
        click_on 'Create Task'
        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_content 'test'
        expect(page).to have_content 'test content'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        FactoryBot.create(:task)
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
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