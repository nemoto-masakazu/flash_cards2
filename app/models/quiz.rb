class Quiz < ApplicationRecord
  belongs_to :user

  # 登録単語が３個以上あるか
  def self.more_than_3_words?(id)
    if Word.where(user_id: id).count > 2
      return false
    else
      return true
    end
  end

  # ランキングを取得
  def get_ranking
    ranking = User.joins(:quizzes).select("users.id,
                                           users.name,
                                           quizzes.correct_answers,
                                           quizzes.updated_at").order("quizzes.correct_answers,
                                                                       quizzes.updated_at").reverse_order
    return ranking
  end

  # 答えのダミーを取得
  def get_dummies(id, question)
    dummies = Word.where(user_id: id).where.not(english: question).order("random()").limit(2)
    return dummies
  end

end
