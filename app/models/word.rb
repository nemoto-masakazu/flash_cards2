class Word < ApplicationRecord

  #全角文字の正規表現
  CapitalLetter = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/

  #日本語validation
  validates :japanese, {presence: true, uniqueness: true, format: {with: CapitalLetter}}
  #英語validation
  validates :english, {presence: true, uniqueness: true, format: {without: CapitalLetter}}
end
