class User < ApplicationRecord
  has_many :quizzes

  # destroyを論理削除に、really_destroyを物理削除に
  acts_as_paranoid

  # パスワードをハッシュ化
  has_secure_password

  # 全角正規表現
  CapitalLetter = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  validates :name, {presence: true, uniqueness: true, length: {minimum: 3 }, format: {without: CapitalLetter}}
  validates :password, {presence: true}

  def get_a_registered_user(id)
    user = User.find_by_id(id)
    return user
  end

end
