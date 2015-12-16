set :stage, :production
server '52.35.198.134', user: 'centos', roles: %w{web app db}
set :deploy_to, "/var/www/test"
set :branch, "development"
set :pty, false
