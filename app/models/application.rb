class Application < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :job
  has_many :applicant_messages
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 400 }
  validates :email, presence: true
end