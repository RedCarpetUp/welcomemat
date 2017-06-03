class Job < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organisation
  has_many :applications, dependent: :destroy
  has_and_belongs_to_many :collaborators, :join_table => :jobs_collaborators, foreign_key: "collaborator_id", class_name: "User", association_foreign_key: "job_id"
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 400 }
  validate :each_item_in_fields
 
  def each_item_in_fields
    min_length_failed = false
    max_length_failed = false
    no_repeat_failed = false
    fields.each do |field|
      if field.downcase == "name" or field.downcase == "description" or field.downcase == "email"
        if !no_repeat_failed
          errors.add(:fields, "items must not be email, name or description")
        end
        no_repeat_failed = true
      end
      if field.length < 4
        if !min_length_failed
          errors.add(:fields, "items must be atleast 4 characters")
        end
        min_length_failed = true
      end
      if field.length > 40
        if !max_length_failed
          errors.add(:fields, "items must be atmost 40 characters")
        end
        max_length_failed = true
      end
    end
  end

  def fields_required=(des)
    self[:fields] = des.split(",").map { |s| s.lstrip.rstrip }
  end

  def fields_required
    self[:fields].join(", ")
  end

end