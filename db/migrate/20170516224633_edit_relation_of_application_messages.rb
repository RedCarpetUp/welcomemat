class EditRelationOfApplicationMessages < ActiveRecord::Migration[5.1]
  def change
  	remove_column :applicant_messages, :job_id
  	add_column :applicant_messages, :user_id, :integer
  end
end
