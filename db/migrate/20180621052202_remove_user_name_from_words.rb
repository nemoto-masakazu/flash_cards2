class RemoveUserNameFromWords < ActiveRecord::Migration[5.2]
  def change
    remove_column :words, :user_name, :string
  end
end
