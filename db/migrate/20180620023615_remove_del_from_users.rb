class RemoveDelFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :del, :boolean
  end
end
