class RemoveSoftDestroyedAtFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :soft_destroyed_at, :string
  end
end
