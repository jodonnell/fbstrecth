set :application, "stretchlist"
set :repository,  "git@github.com:jodonnell/fbstrecth.git"

set :scm, :git
set :user, "jodonnell"

default_run_options[:pty] = true

set :deploy_to, "/var/stretchlist"

role :web, "screenmold.com"                          # Your HTTP server, Apache/etc
role :app, "screenmold.com"                          # This may be the same as your `Web` server
role :db,  "screenmold.com", :primary => true # This is where Rails migrations will run


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
