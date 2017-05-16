class Job < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organisation
  has_many :applications, dependent: :destroy
  validates :unique_key, presence: true
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 400 }
end