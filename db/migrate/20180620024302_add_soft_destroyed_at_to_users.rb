class AddSoftDestroyedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :soft_destroyed_at, :datetime
    add_index :users, :soft_destroyed_at
  end
end
