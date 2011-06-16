# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Stretchlist::Application.initialize!

FB_PERMS = 'email,user_relationship_details,user_relationships'
