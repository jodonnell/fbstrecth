class Crush < ActiveRecord::Base
  belongs_to :user
  belongs_to :potential
  
  def self.create_list user, potentials, create_time
    potentials = check_list potentials
    user.crushes.where(:active => true).each {|crush| crush.active = false; crush.save!}

    potentials.each do |potential|
      Crush.create :user => user, :potential => potential, :create_time => create_time, :active => true, :emailed => false
    end
  end

  def self.crushes user
    users = []
    user.active_list.each do |potential|
      potential_crush_user = User.find_by_myself_potential_id potential
      users << potential_crush_user if potential_crush_user and potential_crush_user.active_list.include? user.myself_potential
    end
    users
  end

  def self.check_list potentials
    potentials.uniq!
    raise ListTooBigError if potentials.size > max_list_size
    potentials
  end

  private

  def self.max_list_size
    @max_list_size ||= 5
  end

  def self.max_list_size=(size)
    @max_list_size = size
  end

end
