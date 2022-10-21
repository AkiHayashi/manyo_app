require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "",
                           email: "aki@ex.com",
                           password: "password",
                           password_confirmation: "password",
                           admin: true)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "aki",
                           email: "",
                           password: "password",
                           password_confirmation: "password",
                           admin: true)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "aki",
                           email: "aki@ex.com",
                           password: "",
                           password_confirmation: "password",
                           admin: true)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        FactoryBot.create(:user, email: "aki@ex.com")
        user = User.create(name: "aki",
                           email: "aki@ex.com",
                           password: "password",
                           password_confirmation: "password",
                           admin: true)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: "aki",
                           email: "aki@ex.com",
                           password: "1",
                           password_confirmation: "1",
                           admin: true)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.create(name: "aki",
                           email: "aki@ex.com",
                           password: "password1",
                           password_confirmation: "password",
                           admin: true)
        expect(user).not_to be_valid
      end
    end
  end
end