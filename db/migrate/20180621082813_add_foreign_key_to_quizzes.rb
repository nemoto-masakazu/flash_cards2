class AddForeignKeyToQuizzes < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :quizzes, :users, column: :user_id
  end
end
