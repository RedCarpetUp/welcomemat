class OrganisationIdFromBooleanToInteger < ActiveRecord::Migration[5.1]
  def change
  	remove_column :templates, :organisation_id
  	add_column :templates, :organisation_id, :integer
  end
end
