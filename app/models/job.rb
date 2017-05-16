class Job < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organisation
  has_many :applications, dependent: :destroy
  has_and_belongs_to_many :collaborators, :join_table => :jobs_collaborators, foreign_key: "collaborator_id", class_name: "User", association_foreign_key: "job_id"
  validates :unique_key, presence: true
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 400 }
end