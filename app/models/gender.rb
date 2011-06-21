class Gender < ActiveRecord::Base
  def self.find_by_gender_or_get_none gender_string
    gender = find_by_gender gender_string
    if gender.nil?
      gender = find_by_gender 'none'
    end
    gender
  end
end
