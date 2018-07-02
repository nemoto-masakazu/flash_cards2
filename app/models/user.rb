class User < ApplicationRecord
  has_many :quizzes

  acts_as_paranoid

  has_secure_password

  CapitalLetter = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  validates :name, {presence: true, uniqueness: true, length: {minimum: 3 }, format: {without: CapitalLetter}}

 # validates :password, {presence: true, uniqueness: true, length: {minimum: 8 }, format: {without: CapitalLetter}}
  validates :password, {presence: true}

end
