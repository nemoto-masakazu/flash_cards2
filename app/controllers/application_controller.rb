class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :user_logged_in?

  def user_logged_in?
    if session[:user_id]
      begin
        @current_user = User.find_by(id: session[:user_id])
      rescue ActiveRecord::RecordNotFound
        reset_user_session
      end
    end
    return if @current_user
    # @current_userが取得できなかった場合はログイン画面にリダイレクト
    flash[:notice] = "そのページはログインしないと見れないよ！"
    redirect_to "/sessions/login"
  end

  def reset_user_session
    session[:user_id] = nil
    @current_user = nil
  end

  def destroy_quiz_session
    #sessionのクイズデータを削除
    session.delete(:ref)
    session.delete(:questions)
    session.delete(:question)
    session.delete(:questionCounter)
    session.delete(:correctCounter)
    session.delete(:questionNum)
  end

end
