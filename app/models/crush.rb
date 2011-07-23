class Crush < ActiveRecord::Base
  belongs_to :user
  belongs_to :potential
  
  def self.create_list user, potentials, create_time
    check_list potentials
    deactivate_last_list user
    potentials_to_crushes user, potentials, create_time
  end

  def self.matches user
    users = []
    user.active_list.each do |potential|
      potential_crush_user = User.find_by_myself_potential_id potential
      users << potential_crush_user if potential_crush_user and potential_crush_user.active_list.include? user.myself_potential
    end
    users
  end

  private

  def self.check_list potentials
    potentials.uniq!
    raise ListTooBigError if potentials.size > max_list_size
  end

  def self.deactivate_last_list user
    user.crushes.where(:active => true).each {|crush| crush.active = false; crush.save!}
  end

  def self.potentials_to_crushes user, potentials, create_time
    potentials.each do |potential|
      Crush.create :user => user, :potential => potential, :create_time => create_time, :active => true, :emailed => false
    end
  end

  def self.max_list_size
    @max_list_size ||= 5
  end

  def self.max_list_size=(size)
    @max_list_size = size
  end

end
