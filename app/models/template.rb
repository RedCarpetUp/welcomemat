class Template < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organisation, optional: true
  validates :content, presence: true, length: { minimum: 5, maximum: 400 }
  validates :name, presence: true, length: { minimum: 5, maximum: 40 }
end