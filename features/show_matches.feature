Feature: Show Matches Feature

  So that I can find ladies to love
  As a dude looking to love
  I want to see woman to kiss

  Scenario: I see some women to select
  Given a user
  When I visit the show matches page
  Then I see "Jacob O'Donnell" as one of my options

  Scenario: I see some men to select but I want women
  Given a user
  When I visit the show matches page and change to view "female"
  Then I see "Sarah Goodman" as one of my options
  
  Scenario: I see a special lady and want to save her
  Given a user
  When I visit the show matches page and choose "Sarah Goodman"
  And I logout and login as "Sarah Goodman"
  And "Sarah Goodman" selects me
  Then I have created a match list with "Sarah Goodman"