class EditDefaultCaseForApplications < ActiveRecord::Migration[5.1]
  def change
  	remove_column :applications, :extra_fields, :jsonb
  	add_column :applications, :extra_fields, :jsonb, default: {}
  end
end
