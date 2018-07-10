class Word < ApplicationRecord

  #全角文字の正規表現
  CapitalLetter = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/

  #日本語validation
  validates :japanese, {presence: true, format: {with: CapitalLetter}}
  validates :japanese, :uniqueness => {:scope => :user_id}
  #英語validation
  validates :english, {presence: true, format: {without: CapitalLetter}}
  validates :english, :uniqueness => {:scope => :user_id}

  # id,user_idに基づいて単語を取得
  def get_a_registered_word(i, j)
    word = Word.find_by(id: i, user_id: j)
    return word
  end

end
