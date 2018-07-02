class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :user_name
      t.string :japanese, unique: true
      t.string :english, unique: true

      t.timestamps
    end
  end
end
