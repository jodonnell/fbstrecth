require 'spec_helper'

describe User do
  fixtures :genders
  fixtures :friends
  fixtures :users

  it "needs a gender" do
    user = User.create :fbid => 1, :email => "bob@bob.com", :username => "bob", :access_token => ""
    user.should_not be_valid
  end
  
  describe "matches" do
    it "gets matches correctly" do
      matches = users(:bob).get_matches
      matches.should include friends(:sally)
      matches.should_not include friends(:fred)
    end

    it "gets gay matches correctly" do
      users(:bob).interested_in_local = Gender.male
      matches = users(:bob).get_matches
      matches.should include friends(:fred)
      matches.should_not include friends(:sally)
    end


    it "gets bisexual matches correctly" do
      users(:bob).interested_in_local = Gender.bisexual
      matches = users(:bob).get_matches
      matches.should include friends(:fred)
      matches.should include friends(:sally)
    end

    it "gets fallback preference correctly" do
      users(:bob).interested_in = nil
      users(:bob).interested_in_local = nil
      
      matches = users(:bob).get_matches
      matches.should include friends(:sally)
      matches.should_not include friends(:fred)
    end

    it "gets facebook preference correctly" do
      users(:bob).interested_in = Gender.male
      users(:bob).interested_in_local = nil
      matches = users(:bob).get_matches
      matches.should include friends(:fred)
      matches.should_not include friends(:sally)
    end

    it "gets local preference correctly" do
      users(:bob).interested_in_local = Gender.male
      matches = users(:bob).get_matches
      matches.should include friends(:fred)
      matches.should_not include friends(:sally)
    end
  end
end
