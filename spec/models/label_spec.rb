require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = FactoryBot.create(:user, email: 'test@ex.com')
        label = Label.create(name: '', user: user)
        expect(label).not_to be_valid
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
        user = FactoryBot.create(:user,email: 'testtest@ex.com')
        label = Label.create(name: 'テスト', user: user)
        expect(label).to be_valid
      end
    end
  end
end