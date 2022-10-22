class Admin::UsersController < ApplicationController
  before_action :admin_role_required

  def index
    @users = User.preload(:tasks).order(:id)
  end

  def new
    @user = User.new
  end
  

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'ユーザを登録しました'
    else
      @user
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザを更新しました'
    else
      @user
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: 'ユーザを削除しました'
    else
      redirect_to admin_users_path, notice: '管理者が0人になるため削除できません'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def admin_role_required
    redirect_to tasks_path, notice: '管理者以外はアクセスできません' unless current_user.admin?
  end
end
