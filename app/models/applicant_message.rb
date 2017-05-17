class ApplicantMessage < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  belongs_to :application
  validates :content, presence: true, length: { minimum: 5, maximum: 400 }
  validates_inclusion_of :from_applicant, :in => [true, false]
end