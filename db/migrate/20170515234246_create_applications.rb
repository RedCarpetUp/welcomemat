class CreateApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :applications do |t|
      t.text :description
      t.string :name
      t.integer :job_id
      t.timestamps
    end
  end
end
