class EditUsersIndexForEmail < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: true, where: 'deleted_at IS NOT NULL'
  end
end
