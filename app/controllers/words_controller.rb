class WordsController < ApplicationController
  before_action :correct_user, only: [:show, :edit, :update, :destroy]


  def new
    @word = Word.new
  end

  #per()の数字で何個表示するか
  def index
    @words = Word.where(user_id: session[:user_id]).page(params[:page]).per(10)
  end

  def show
    @word = Word.find_by(id: params[:id])

    # mechanizeを利用してスクレイピング、例文として利用
    agent = Mechanize.new
    page = agent.get("https://ejje.weblio.jp/content/#{@word.english}")
    @example = page.search("table.KejjeYr div.KejjeYrHd")

  end

  def edit
    @word = Word.find_by(id: params[:id])
  end

  def destroy
    @word = Word.find_by(id: params[:id])
    if @word.destroy
      redirect_to("/words/index")
    else
      render "show"
    end
  end

  def update
    @word = Word.find_by(id: params[:id])
    if @word.update_attributes(word_params)
      # 更新に成功したときの処理
      render "show"
    else
      render "edit"
    end
  end

  def create
    @word = Word.new(word_params)
    @word.user_id = session[:user_id]
    if @word.save
      #flash[:notice] = "単語の登録が完了しました"
      redirect_to controller: "words", action: "index"
      #redirect_to("/words/index")
    else
      render("words/new")
    end
  end

  private
    def word_params
      params.require(:word).permit(:japanese, :english)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = @current_user
      redirect_to("/words/index") unless @user == current_user
    end

end
