class Application < ActiveRecord::Base
  acts_as_paranoid
  include PgSearch
  pg_search_scope :search_by_details, :against => [:name, :description, :email]
  include Hashid::Rails
  belongs_to :job
  has_many :applicant_messages
  has_many :extra_applicant_emails
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 400 }
  validates :email, presence: true
  validate :each_item_in_fields
  validates :status, presence: true
  validates_inclusion_of :status, :in => ["Shortlisted", "Applied", "Rejected", "Hired", "Moved Out", "Moved In"]

  def each_item_in_fields
    min_length_failed = false
    max_length_failed = false
    required_failed = false
    numeric_format_failed = false
    date_format_failed = false
    proper_fields_present_failed = false
    #ensure if any is missing in application but is in job's fields, its added as blank
    if extra_fields.keys.sort != self.job.fields["entries"].map {|x| x["name"]}.sort
      if !proper_fields_present_failed
        errors.add(:fields, "Improper form data, try Again")
      end
      proper_fields_present_failed = true
      return
    end
    extra_fields.keys.each do |field|
      if self.job.fields["entries"].map {|x| x["name"]}.include?(field)
        field_in_job_entry = self.job.fields["entries"].select {|f| f["name"] == field}.first
        if field_in_job_entry["type"] == "text"
          if extra_fields[field] != ""
            if extra_fields[field].length < 4
              if !min_length_failed
                errors.add(:fields, "content must be atleast 4 characters")
              end
              min_length_failed = true
            end
            if extra_fields[field].length > 40
              if !max_length_failed
                errors.add(:fields, "content must be atmost 40 characters")
              end
              max_length_failed = true
            end
          else
            if field_in_job_entry["required"]
              if !required_failed
                errors.add(:fields, "Starred entries can't be empty")
              end
              required_failed = true
            end
          end
        elsif field_in_job_entry["type"] == "numeric"
          if extra_fields[field] != ""
            if !/\A\d+\z/.match(extra_fields[field])
              if !numeric_format_failed
                errors.add(:fields, "Numeric fields have to submit a number")
              end
              numeric_format_failed = true
            end
          else
            if field_in_job_entry["required"]
              if !required_failed
                errors.add(:fields, "Starred entries can't be empty")
              end
              required_failed = true
            end
          end
        elsif field_in_job_entry["type"] == "date"
          if extra_fields[field] != ""
            if !is_valid_date? extra_fields[field]
              if !date_format_failed
                errors.add(:fields, "Date fields have to submit a valid date")
              end
              date_format_failed = true
            end
          else
            if field_in_job_entry["required"]
              if !required_failed
                errors.add(:fields, "Starred entries can't be empty")
              end
              required_failed = true
            end
          end
        end
      else
        #This will happen if form is tampered to add more details
        #OR job's form was changed betwwen applicaiton form load and submission
        #In either case I can't save the form as it doesn't comply with CURRENT requirments
        if !proper_fields_present_failed
          errors.add(:fields, "Improper form data, try Again")
        end
        proper_fields_present_failed = true
      end
    end
  end

  private

  def is_valid_date?(date_string)
    begin
      parsed_date = Date.strptime(date_string, '%Y-%m-%d')
      return parsed_date.to_s == date_string
    rescue
      return false
    end
  end

end