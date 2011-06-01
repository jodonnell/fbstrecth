# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Stretchlist::Application.initialize!

FB_APP_ID = "210100592345280"
FB_SECRET = "5f1ca141c3865addcbea22f09221e05d"
HOST_NAME = "stretchlist.com:3000"
FB_PERMS = 'email,user_relationship_details,user_relationships'
