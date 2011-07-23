require 'spec_helper'

describe User do
  fixtures :genders
  fixtures :potentials
  fixtures :users

  it "needs a gender" do
    user = User.create :fbid => 1, :email => "bob@bob.com", :username => "bob", :access_token => ""
    user.should_not be_valid
  end

  it "sends an email to matched users" do
    mailer_mock = mock('Mailer')
    mailer_mock.stub(:deliver)
    MatchMailer.should_receive(:match).twice.and_return(mailer_mock)
    
    users(:bob).create_list [potentials(:sally)]
    users(:sally).create_list [potentials(:bob)]
    users(:bob).make_matches
  end
  
  describe "matches" do
    it "gets matches correctly" do
      matches = users(:bob).get_potential_crushes
      matches.should include potentials(:sally)
      matches.should_not include potentials(:fred)
    end

    it "gets gay matches correctly" do
      users(:bob).interested_in_local = Gender.male
      matches = users(:bob).get_potential_crushes
      matches.should include potentials(:fred)
      matches.should_not include potentials(:sally)
    end


    it "gets bisexual matches correctly" do
      users(:bob).interested_in_local = Gender.bisexual
      matches = users(:bob).get_potential_crushes
      matches.should include potentials(:fred)
      matches.should include potentials(:sally)
    end

    it "gets fallback preference correctly" do
      users(:bob).interested_in = nil
      users(:bob).interested_in_local = nil
      
      matches = users(:bob).get_potential_crushes
      matches.should include potentials(:sally)
      matches.should_not include potentials(:fred)
    end

    it "gets facebook preference correctly" do
      users(:bob).interested_in = Gender.male
      users(:bob).interested_in_local = nil
      matches = users(:bob).get_potential_crushes
      matches.should include potentials(:fred)
      matches.should_not include potentials(:sally)
    end

    it "gets local preference correctly" do
      users(:bob).interested_in_local = Gender.male
      matches = users(:bob).get_potential_crushes
      matches.should include potentials(:fred)
      matches.should_not include potentials(:sally)
    end
  end
end
