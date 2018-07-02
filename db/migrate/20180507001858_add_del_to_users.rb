class AddDelToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :del, :boolean, :default => false
  end
end
