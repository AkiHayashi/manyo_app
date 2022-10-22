class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :logout_required, only: [:new, :create]
  before_action :correct_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to tasks_path, notice: t('.created')
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
      redirect_to user_path(@user.id), notice: t('.updated')
    else
      @user
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to tasks_path, notice: 'アクセス権限がありません' unless current_user?(@user) || current_user.admin?
  end
end
