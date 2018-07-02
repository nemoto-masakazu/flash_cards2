class UsersController < ApplicationController
  skip_before_action :user_logged_in?, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]


  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功したときの処理
      render "show"
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.destroy
      redirect_to("/sessions/login")
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
      redirect_to("/top")
    else
      render("users/new")
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
      @user = User.find(params[:id])
      flash[:caution] = "自分のユーザーしか編集できません"
      redirect_to("/users/index") unless @user == current_user
    end

end
