class JobsCollaboratorsJoin < ActiveRecord::Migration[5.1]
  def change
    create_table 'jobs_collaborators', :id => false do |t|
      t.column :job_id, :integer
      t.column :collaborator_id, :integer
    end
  end
end
