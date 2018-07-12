class WordsController < ApplicationController
  before_action :user_logged_in?
  before_action :correct_user, only: [:show, :edit, :update, :destroy, :index]
  before_action :destroy_quiz_session


  def new
    @word = Word.new
  end

  def index
    @words = Word.where(user_id: session[:user_id]).page(params[:page]).per(10) #per()の数字で何個表示するか

    if @words.empty?
      flash.now[:words_none] = "まだ単語が未登録です。単語を登録してください"
    end
  end

  def show
    @word = Word.new.get_a_registered_word(params[:id], session[:user_id])
    if @word.nil?
      #flash.now[:unregister] = "そのurlは許可されていません"
      redirect_to "/words/index"
    else
      # mechanizeを利用してスクレイピング、例文として利用
      agent = Mechanize.new
      page = agent.get("https://ejje.weblio.jp/content/#{@word.english}")
      example = page.search("table.KejjeYr div.KejjeYrHd")

      if example.inner_text.empty?
        @example = ["Sorry", "We couldn't find any examples"]
      else
        @example = example.first(2).map{|e| e.inner_text}
      end
    end

  end

  def edit
    @word = Word.new.get_a_registered_word(params[:id], session[:user_id])
    if @word.nil?
      #flash.now[:unregister] = "そのurlは許可されていません"
      redirect_to "/words/index"
    end
  end

  def destroy
    @word = Word.new.get_a_registered_word(params[:id], session[:user_id])
    if @word.nil?
      #flash.now[:unregister] = "そのurlは許可されていません"
      redirect_to "/words/index"
    else
      if @word.destroy
        redirect_to "/words/index"
      else
        render "show"
      end
    end
  end

  def update
    @word = Word.new.get_a_registered_word(params[:id], session[:user_id])
    if @word.nil?
      #flash.now[:unregister] = "そのurlは許可されていません"
      redirect_to "/words/index"
    else
      if @word.update_attributes(word_params)
        # 更新に成功したときの処理
        redirect_to controller: "words", action: "show"
      else
        render "edit"
      end
    end
  end

  def create
    @word = Word.new(word_params)
    @word.user_id = session[:user_id]
    if @word.save
      #flash[:notice] = "単語の登録が完了しました"
      redirect_to "/words/index"
    else
      render "words/new"
    end
  end

  private
    def word_params
      params.require(:word).permit(:japanese, :english)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find_by_id(session[:user_id])
      redirect_to("/words/index") unless @user == current_user
    end

end
