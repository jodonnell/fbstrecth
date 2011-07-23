module CucumberHelper
  def sarah_goodman
    Hashie::Mash.new(:fbid => 100002588533672, :id => Potential.find_by_fbid(100002588533672).id)
  end

  def string_to_identifier string
    string.downcase!
    string.gsub!(/ /, '_')
  end
end

World(CucumberHelper)
