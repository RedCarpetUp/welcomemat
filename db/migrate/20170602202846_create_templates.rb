class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :templates do |t|
      t.text :content
      t.boolean :organisation_id
    end
    add_column :templates, :deleted_at, :datetime
    add_index :templates, :deleted_at
  end
end
