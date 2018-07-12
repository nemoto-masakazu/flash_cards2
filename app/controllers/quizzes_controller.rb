class QuizzesController < ApplicationController
  before_action :user_logged_in?
  before_action :destroy_quiz_session, only: [:new]

  def new
    #ユーザーをランキングに登録
    @quiz = Quiz.new
    if Quiz.where(user_id: session[:user_id]).empty?
      @quiz.user_id = session[:user_id]
      @quiz.save
    end
  end

  def show
    # 単語が３子以上あるか登録されているかチェック
    # 登録なければ登録ページに
    if Quiz.more_than_3_words?(session[:user_id])
      flash.now[:words_none] = "3個以上単語を登録しないと、クイズには挑戦出来ません"
      render "words/new"
    else
      # リロードの判定
      # リロードしていたらelseに
      if request.path_info != session[:ref]
        session[:ref] = request.path_info

        #クイズに使う英単語をデータベースより引き出す
        if session[:questions].blank?
          selectQuestions = Word.where(user_id: session[:user_id]).order("random()").limit(30)

          @questions = {}
          selectQuestions.each do |question|
            @questions[question.english] = question.japanese
          end
          session[:questions] = @questions

          #一つの英単語と回答に使用する日本語訳を準備
          @question = @questions.sort_by{rand}[0][0]
          session[:question] = @question
          dummies = Quiz.new.get_dummies(session[:user_id], @question)
          choices = []
          dummies.each do |dummy|
            choices.push(dummy.japanese)
          end
          choices.push(@questions[@question])
          choices = choices.sort_by{rand}
          @choices = choices

          #問題数、正答数のカウンタ
          session[:questionCounter] = @questions.length
          session[:questionNum] = 1
          session[:correctCounter] = 0
        end

        #一つの英単語と回答に使用する日本語訳を準備
        @questions = session[:questions]
        @question = @questions.sort_by{rand}[0][0]
        session[:question] = @question
        dummies = Quiz.new.get_dummies(session[:user_id], @question)
        choices = []
        dummies.each do |dummy|
          choices.push(dummy.japanese)
        end
        choices.push(@questions[@question])
        choices = choices.sort_by{rand}
        @choices = choices

        @questionNum = session[:questionNum]
      else
        session[:ref] = nil
        flash[:failure] = "失格になりました。"
        redirect_to "/home/show"
      end

    end
  end

  def answer
    # リロードの判定
    # リロードしていたらelseに
    if request.path_info != session[:ref]
      session[:ref] = request.path_info

      # 回答が合っていれば、正答数を一つ増やす
      # 残りの問題数を一つ減らす
      # 出題済みの問題を一つ減らす
      # @judgeAnswer:viewで正解か不正解かで分岐
      question = session[:question]
      questions = session[:questions]
      session[:questionNum] = session[:questionNum] + 1
      correctJapanese = questions[question]
      cC = session[:correctCounter]
      judgeAnswer = false
      if correctJapanese == params[:answer]
         cC = cC + 1
        session[:correctCounter] = cC
        judgeAnswer = true
      end
      questions.delete(question)
      session[:questions] = questions
      session[:questionCounter] = questions.length

      @question = question
      @correctJapanese = correctJapanese
      @judgeAnswer = judgeAnswer
      @questionsLength = questions.length

    else
      session[:ref] = nil # リロード判定のセッションを破棄
      flash[:failure] = "失格になりました。"
      redirect_to "/home/show"
    end

  end

  def result
    if session[:ref]
      session[:ref] = nil # リロード判定のセッションを破棄
    end
    # 何問だったか
    session[:questionNum] = session[:questionNum] - 1


    if session[:correctCounter].nil?

      #ランキングレコード取得
      @ranking = Quiz.new.get_ranking

      # ランキング表示
      @rankAmount = Quiz.rank_count
      @yourRank = 0
      @ranking.each do |r|
        if r.id != session[:user_id]
          @yourRank = @yourRank + 1
        else r.id == session[:user_id]
          @yourRank = @yourRank + 1
          break
        end
      end

    else

      # 正答率の登録
      @quiz = Quiz.find_by(user_id: session[:user_id])
      if @quiz.correct_answers.blank? || @quiz.correct_answers < session[:correctCounter]
        @quiz.correct_answers = session[:correctCounter]
        @quiz.save
      end

      #ランキング取得
      @ranking = Quiz.new.get_ranking

      # ランキング表示
      @rankAmount = Quiz.rank_count
      @yourRank = 0
      @ranking.each do |r|
        if r.id != session[:user_id]
          @yourRank = @yourRank + 1
        else r.id == session[:user_id]
          @yourRank = @yourRank + 1
          break
        end
      end
    end
  end

end
