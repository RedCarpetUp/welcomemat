class CreateExtraApplicantEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :extra_applicant_emails do |t|
      t.string :email
      t.boolean :is_greyed, default: false
      t.integer :application_id
    end
    add_column :extra_applicant_emails, :deleted_at, :datetime
    add_index :extra_applicant_emails, :deleted_at
  end
end
