class AddTimestamps < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
    add_column :applicant_messages, :created_at, :datetime
    add_column :applicant_messages, :updated_at, :datetime
    add_column :templates, :created_at, :datetime
    add_column :templates, :updated_at, :datetime
  end
end
