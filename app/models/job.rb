class Job < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organisation
  has_many :applications, dependent: :destroy
  has_and_belongs_to_many :collaborators, :join_table => :jobs_collaborators, foreign_key: "collaborator_id", class_name: "User", association_foreign_key: "job_id"
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 1000 }
  validate :each_item_in_fields

  def each_item_in_fields
    invalid_format = false
    invalid_name_min_length = false
    invalid_name_max_length = false
    invalid_name_repeat = false
    invalid_multiples = false
    ["entries"].map {|x| x["name"]}.each_with_object(Hash.new(0)){|key,hash| hash[key] += 1}
    fields["entries"].map {|x| x["name"]}.each do |freq_item|
      if fields["entries"].map {|x| x["name"]}.each_with_object(Hash.new(0)){|key,hash| hash[key] += 1}[freq_item] > 1
        invalid_multiples = true
      end
    end
    fields["entries"].each do |entry|
      #Is comparing arrays like this ok ?
      if entry.keys.sort == ["name", "type", "required"].sort and ["numeric", "text", "date"].include?(entry["type"]) and [true, false].include?(entry["required"])
        #Only one of these will be true, per entry
        if entry["name"].length < 4
          invalid_name_min_length = true
        end
        if entry["name"].length > 40
          invalid_name_max_length = true
        end
        if ["name", "description", "email"].include?(entry["name"].downcase)
          invalid_name_repeat = true
        end
      else
        invalid_format = true
      end
    end
    if invalid_format
      errors.add(:fields, "invalid format")
    else
      if invalid_multiples
        errors.add(:fields, "items must not be same")
      end
      if invalid_name_repeat
        errors.add(:fields, "items must not be email, name or description")
      end
      if invalid_name_min_length
        errors.add(:fields, "items must be atleast 4 characters")
      end
      if invalid_name_max_length
        errors.add(:fields, "items must be atmost 40 characters")
      end
    end
  end

  def fields_required=(des)
    self[:fields] = ActiveSupport::JSON.decode(des)
  end

  def fields_required
    ActiveSupport::JSON.encode(self[:fields])
  end

end