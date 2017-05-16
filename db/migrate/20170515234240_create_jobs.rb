class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.text :description
      t.string :name
      t.string :unique_key
      t.integer :organisation_id
      t.timestamps
    end
  end
end
