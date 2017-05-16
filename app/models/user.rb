class User < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organisation, optional: true
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :email, presence: true
end