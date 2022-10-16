require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "task_title",	with: "test" 
        fill_in "task_content",	with: "test content" 
        fill_in 'task[deadline_on]',	with: "002025-03-03" 
        find("#task_priority").find("option[value='低']").select_option
        find("#task_status").find("option[value='未着手']").select_option
        click_on '登録する'
        expect(page).to have_content 'タスクを登録しました'
        expect(page).to have_content 'test'
        expect(page).to have_content 'test content'
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_task) do
      FactoryBot.create(:task, 
                        title: '書類作成',
                        content: 'テスト１',
                        created_at: Time.zone.local(2022, 2, 18),
                        deadline_on: Time.zone.local(2025, 03, 03),
                        priority: :低,
                        status: :着手中)
    end
    let!(:second_task) do
      FactoryBot.create(:task, 
                        title: '競合調査',
                        content: 'テスト２',
                        created_at: Time.zone.local(2022, 2, 17),
                        deadline_on: Time.zone.local(2025, 03, 01),
                        priority: :中,
                        status: :未着手)
    end
    let!(:third_task) do
      FactoryBot.create(:task, 
                        title: 'タスク管理',
                        content: 'テスト３',
                        created_at: Time.zone.local(2022, 2, 16),
                        deadline_on: Time.zone.local(2025, 03, 02),
                        priority: :高,
                        status: :完了)
    end

    before { visit tasks_path }

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('body tr')
        expect(task_list[1].text).to have_content('書類作成 テスト１')
        expect(task_list[2].text).to have_content('競合調査 テスト２')
        expect(task_list[3].text).to have_content('タスク管理 テスト３')
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        click_on 'タスクを登録する'
        visit new_task_path
        fill_in "task_title",	with: "test" 
        fill_in "task_content",	with: "test content" 
        fill_in 'task[deadline_on]',	with: "002025-03-03" 
        find("#task_priority").find("option[value='低']").select_option
        find("#task_status").find("option[value='未着手']").select_option
        click_on '登録する'

        task_list = all('body tr')
        expect(task_list[1].text).to have_content('test')
        expect(task_list[2].text).to have_content('書類作成')
        expect(task_list[3].text).to have_content('競合調査')
      end
    end

    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          click_on '終了期限'
          sleep 2

          task_list = all('body tr')
          expect(task_list[1].text).to have_content('競合調査')
          expect(task_list[2].text).to have_content('タスク管理')
          expect(task_list[3].text).to have_content('書類作成')
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          click_on '優先度'
          sleep 2

          task_list = all('body tr')
          expect(task_list[1].text).to have_content('タスク管理')
          expect(task_list[2].text).to have_content('競合調査')
          expect(task_list[3].text).to have_content('書類作成')
        end
      end
    end
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in 'search[title]',	with: "調査" 
          click_on '検索'

          expect(page).to have_content('競合調査')
          expect(page).not_to have_content('タスク管理')
          expect(page).not_to have_content('書類作成')
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          find("#search_status").find("option[value='未着手']").select_option
          click_on '検索'

          expect(page).to have_content('競合調査')
          expect(page).not_to have_content('タスク管理')
          expect(page).not_to have_content('書類作成')
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          fill_in 'search[title]',	with: "調査" 
          find("#search_status").find("option[value='未着手']").select_option
          click_on '検索'

          expect(page).to have_content('競合調査')
          expect(page).not_to have_content('タスク管理')
          expect(page).not_to have_content('書類作成')
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        end
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task, title: '競合調査', content: '他社のサービスを調査する。')
        visit task_path(task)
        expect(page).to have_content '競合調査'
        expect(page).to have_content '他社のサービスを調査する。'
      end
    end
  end
end