class MoveUniqueKeyToApplications < ActiveRecord::Migration[5.1]
  def change
  	remove_column :jobs, :unique_key, :string
  	add_column :applications, :unique_key, :string
  end
end
