class Application < ActiveRecord::Base
  acts_as_paranoid
  include Hashid::Rails
  belongs_to :job
  has_many :applicant_messages
  validates :name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :description, presence: true, length: { minimum: 5, maximum: 400 }
  validates :email, presence: true
  validate :each_item_in_fields
 
  def each_item_in_fields
    min_length_failed = false
    max_length_failed = false
    extra_fields.keys.each do |field|
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
    end
  end

end