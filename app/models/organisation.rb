class Organisation < ActiveRecord::Base
  acts_as_paranoid
  has_many :jobs, dependent: :destroy
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 400 }
end