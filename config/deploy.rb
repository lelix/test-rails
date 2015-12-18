SSHKit.config.command_map[:rake] = "bundle exec rake"
# config valid only for current version of Capistrano

set :application, 'test'
set :repo_url, 'https://github.com/lelix/test-rails.git'
set :branch, "development"

set :stages, ["production", "staging"]
set :default_stage, "staging"
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :pty, false
set :deploy_via, :remote_cache
set :scm, :git
set :keep_releases, 5

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :tests, []


# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :setup do
  
  desc "Upload database.yml file."
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! "config/database.yml", "#{shared_path}/config/database.yml"
      upload! "config/secrets.yml", "#{shared_path}/config/secrets.yml"
    end
  end
  
  desc "Seed the database."
  task :seed_db do
    on roles(:app) do
      within "#{release_path}" do
        execute :rake, "db:seed RAILS_ENV=#{fetch :stage}"
      end
    end
  end
#before 'deploy:publishing', 'setup:seed_db'
end
namespace :deploy do
  desc "apache server."
  task :restart do
    on roles(:app) do
      within "#{release_path}" do
#        execute :sudo, "systemctl restart httpd.service"
	execute :sudo, "service apache2 restart"
      end
    end
  end
after :finishing, 'deploy:restart'
end
