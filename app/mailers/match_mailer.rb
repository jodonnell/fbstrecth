class MatchMailer < ActionMailer::Base
  default :from => "match@stretchlist.com"

  def match(user, potential)
    @name = user.username
    mail(
         :to => user.email,
         :subject => "You have a match!"
         )
  end
end
