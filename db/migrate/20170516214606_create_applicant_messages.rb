class CreateApplicantMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :applicant_messages do |t|
      t.text :content
      t.boolean :from_applicant
      t.integer :job_id
      t.integer :application_id
    end
  end
end
