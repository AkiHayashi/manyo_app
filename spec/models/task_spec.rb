require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  let!(:user) { FactoryBot.create(:user) }

  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '企画会議', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = FactoryBot.create(:task, title: '企画会議', content: '企画書を作成する。', user: user)
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:task_1) do
      FactoryBot.create(:task,
                        title: 'タスクA',
                        deadline_on: Date.new(2025-02-18), 
                        priority: :中, 
                        status: :未着手,
                        user: user)
    end
    let!(:task_2) do
      FactoryBot.create(:task,
                        title: 'タスクB',
                        deadline_on: Date.new(2025-02-17), 
                        priority: :高	, 
                        status: :着手中,
                        user: user)
    end
    let!(:task_3) do
      FactoryBot.create(:task,
                        title: 'タスクC',
                        deadline_on: Date.new(2025-02-18), 
                        priority: :低, 
                        status: :完了,
                        user: user)
    end
    let!(:task_4) do
      FactoryBot.create(:task,
                        title: 'タスクD',
                        deadline_on: Date.new(2025-02-18), 
                        priority: :低, 
                        status: :完了,
                        user: user)
    end

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        expect(Task.search_by_title('A')).to include(task_1)
        expect(Task.search_by_title('A')).not_to include(task_2)
        expect(Task.search_by_title('A')).not_to include(task_3)
        expect(Task.search_by_title('A').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_by_status('着手中'.to_sym)).to include(task_2)
        expect(Task.search_by_status('着手中'.to_sym)).not_to include(task_1)
        expect(Task.search_by_status('着手中'.to_sym)).not_to include(task_3)
        expect(Task.search_by_status('着手中'.to_sym).count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(Task.search_by_title('D').search_by_status('完了'.to_sym)).to include(task_4)
        expect(Task.search_by_title('D').search_by_status('完了'.to_sym)).not_to include(task_1)
        expect(Task.search_by_title('D').search_by_status('完了'.to_sym)).not_to include(task_2)
        expect(Task.search_by_title('D').search_by_status('完了'.to_sym)).not_to include(task_3)

        expect(Task.search_by_title('D').search_by_status('完了'.to_sym).count).to eq 1
      end
    end
  end
end