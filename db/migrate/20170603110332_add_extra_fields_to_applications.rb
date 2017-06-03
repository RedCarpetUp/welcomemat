class AddExtraFieldsToApplications < ActiveRecord::Migration[5.1]
  def change
  	add_column :applications, :extra_fields, :jsonb, default: '{}'
  	add_column :jobs, :fields, :string, array: true, default: []
  end
end
