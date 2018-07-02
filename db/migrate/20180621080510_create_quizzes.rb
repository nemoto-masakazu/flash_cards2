class CreateQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :quizzes do |t|
      t.integer :user_id
      t.integer :correct_answers

      t.timestamps
    end
  end
end
