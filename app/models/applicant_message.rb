class ApplicantMessage < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user, optional: true
  belongs_to :application
  validates :content, presence: true, length: { minimum: 5, maximum: 400 }
end