class QuizzesController < ApplicationController
  def new
    session.delete(:questions)
    session.delete(:question)
    session.delete(:questionCounter)
    session.delete(:correctCounter)
    session.delete(:questionNum)

    @quiz = Quiz.new
    if Quiz.where(user_id: session[:user_id]).empty?
      @quiz.user_id = session[:user_id]
      @quiz.save
    end

  end

  def show
    # リロードの判定
    # リロードしていたらelseに
    if request.path_info != session[:ref]
      session[:ref] = request.path_info

      #クイズに使う英単語をデータベースより引き出す
      if session[:questions].nil?
        selectQuestions = Word.where(user_id: session[:user_id]).order("random()").limit(30)
        @questions = {}
        selectQuestions.each do |question|
          @questions[question.english] = question.japanese
        end
        session[:questions] = @questions

        #一つの英単語と回答に使用する日本語訳を準備
        @question = @questions.sort_by{rand}[0][0]
        session[:question] = @question
        dummies = Word.where.not(english: @question).order("random()").limit(2)
        choices = []
        dummies.each do |dummy|
          choices.push(dummy.japanese)
        end
        choices.push(@questions[@question])
        choices = choices.sort_by{rand}
        @choices = choices

        #問題数、正答数のカウンタ
        session[:questionCounter] = @questions.length
        session[:questionNum] = @questions.length #問題数が何問だったか
        session[:correctCounter] = 0
      end

      #一つの英単語と回答に使用する日本語訳を準備
      @questions = session[:questions]
      @question = @questions.sort_by{rand}[0][0]
      session[:question] = @question
      dummies = Word.where.not(english: @question).order("random()").limit(2)
      choices = []
      dummies.each do |dummy|
        choices.push(dummy.japanese)
      end
      choices.push(@questions[@question])
      choices = choices.sort_by{rand}
      @choices = choices

    else
      session[:ref] = nil
      flash[:failure] = "失格になりました。"
      redirect_to "/top"
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
      @question = session[:question]
      @questions = session[:questions]
      @correctJapanese = @questions[@question]
      @cC = session[:correctCounter]
      @judgeAnswer = false
      if @correctJapanese == params[:answer]
         @cC = @cC + 1
        session[:correctCounter] = @cC
        @judgeAnswer = true
      end
      @questions.delete(@question)
      session[:questions] = @questions
      session[:questionCounter] = @questions.length

      if @questions.length == 0
        redirect_to "/quizzes/result"
      end
    else
      session[:ref] = nil # リロード判定のセッションを破棄
      flash[:failure] = "失格になりました。"
      redirect_to "/top"
    end

  end

  def result
    session[:ref] = nil # リロード判定のセッションを破棄

    if session[:correctCounter].nil?

      #ランキングレコード取得
      @ranking = User.joins(:quizzes).select("users.id,
                                              users.name,
                                              quizzes.correct_answers,
                                              quizzes.updated_at").order("quizzes.correct_answers,
                                                                          quizzes.updated_at").reverse_order

      # ランキング表示
      @rankAmount = Quiz.count("user_id")
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
      @ranking = User.joins(:quizzes).select("users.id,
                                              users.name,
                                              quizzes.correct_answers,
                                              quizzes.updated_at").order("quizzes.correct_answers,
                                                                          quizzes.updated_at").reverse_order

      # ランキング表示
      @rankAmount = Quiz.count("user_id")
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
