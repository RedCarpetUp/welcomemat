class ExtraApplicantEmail < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :application
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
end