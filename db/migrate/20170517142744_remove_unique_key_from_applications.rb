class RemoveUniqueKeyFromApplications < ActiveRecord::Migration[5.1]
  def change
  	remove_column :applications, :unique_key
  end
end
