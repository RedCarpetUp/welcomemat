class AddEmailToApplications < ActiveRecord::Migration[5.1]
  def change
  	add_column :applications, :email, :string
  end
end
