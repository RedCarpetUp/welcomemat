class AddDeletedAtToOrganisations < ActiveRecord::Migration[5.1]
  def change
    add_column :organisations, :deleted_at, :datetime
    add_index :organisations, :deleted_at
  end
end
