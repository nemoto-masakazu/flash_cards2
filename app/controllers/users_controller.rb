class UsersController < ApplicationController
  skip_before_action :user_logged_in?, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :destroy_quiz_session

  def index
    @users = User.all
  end

  def show
    @user = User.new.get_a_registered_user(params[:id])
    if @user.nil?
      redirect_to "/users/index"
    end
  end

  def edit
    @user = User.new.get_a_registered_user(params[:id])
  end

  def update
    @user = User.new.get_a_registered_user(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功したときの処理
      render "show"
    else
      render "edit"
    end
  end

  def destroy
    @user = User.new.get_a_registered_user(params[:id])
    if @user.destroy
      @quiz = Quiz.find_by(user_id: params[:id])
      @quiz.destroy
      reset_session
      redirect_to "/sessions/login"
    else
      render "index"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @quiz = Quiz.new
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to "/sessions/login"
    else
      render "users/new"
    end
  end

  #入力を隠す
  private
    def user_params
      params.require(:user).permit(:name, :password,
                                   :password_confirmation)
    end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find_by_id(params[:id])
    flash[:caution] = "ログインユーザーしか編集できません"
    redirect_to "/users/index" unless @user == current_user
  end

end
