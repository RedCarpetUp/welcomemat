class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_paranoid
  has_many :organisations
  has_and_belongs_to_many :jobs, foreign_key: "collaborator_id", :join_table => :jobs_collaborators
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :email, presence: true
end