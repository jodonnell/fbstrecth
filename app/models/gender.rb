class Gender < ActiveRecord::Base
  def self.find_by_gender_or_get_none gender_string
    gender = find_by_gender gender_string
    gender = find_by_gender 'none' if gender.nil?
    gender
  end

  def self.male
    find_by_gender "male"
  end

  def self.female
    find_by_gender "female"
  end

  def self.bisexual
    find_by_gender "bisexual"
  end

  def self.sexual_orientations
    [self.male, self.female, self.bisexual]
  end

  def to_s
    gender.capitalize
  end
end
