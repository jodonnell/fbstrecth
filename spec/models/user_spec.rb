require 'spec_helper'

describe User do
  fixtures :genders
  fixtures :friends
  fixtures :users

  it "needs a gender" do
    user = User.create :fbid => 1, :email => "bob@bob.com", :username => "bob", :access_token => ""
    user.should_not be_valid
  end

  it "sends an email to matched users" do
    mailer_mock = mock('Mailer')
    mailer_mock.stub(:deliver)
    MatchMailer.should_receive(:match).twice.and_return(mailer_mock)
    
    users(:bob).create_list [friends(:sally)]
    users(:sally).create_list [friends(:bob)]
    users(:bob).make_matches
  end
  
  describe "matches" do
    it "gets matches correctly" do
      matches = users(:bob).get_potential_matches
      matches.should include friends(:sally)
      matches.should_not include friends(:fred)
    end

    it "gets gay matches correctly" do
      users(:bob).interested_in_local = Gender.male
      matches = users(:bob).get_potential_matches
      matches.should include friends(:fred)
      matches.should_not include friends(:sally)
    end


    it "gets bisexual matches correctly" do
      users(:bob).interested_in_local = Gender.bisexual
      matches = users(:bob).get_potential_matches
      matches.should include friends(:fred)
      matches.should include friends(:sally)
    end

    it "gets fallback preference correctly" do
      users(:bob).interested_in = nil
      users(:bob).interested_in_local = nil
      
      matches = users(:bob).get_potential_matches
      matches.should include friends(:sally)
      matches.should_not include friends(:fred)
    end

    it "gets facebook preference correctly" do
      users(:bob).interested_in = Gender.male
      users(:bob).interested_in_local = nil
      matches = users(:bob).get_potential_matches
      matches.should include friends(:fred)
      matches.should_not include friends(:sally)
    end

    it "gets local preference correctly" do
      users(:bob).interested_in_local = Gender.male
      matches = users(:bob).get_potential_matches
      matches.should include friends(:fred)
      matches.should_not include friends(:sally)
    end
  end
end
