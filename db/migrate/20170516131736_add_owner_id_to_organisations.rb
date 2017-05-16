class AddOwnerIdToOrganisations < ActiveRecord::Migration[5.1]
  def change
  	add_column :organisations, :owner_id, :integer
  end
end
