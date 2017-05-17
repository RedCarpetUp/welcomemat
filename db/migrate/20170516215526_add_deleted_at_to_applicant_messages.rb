class AddDeletedAtToApplicantMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :applicant_messages, :deleted_at, :datetime
    add_index :applicant_messages, :deleted_at
  end
end
