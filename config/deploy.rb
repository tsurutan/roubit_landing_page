lock "3.7.0"

set :application, "roubit_landing_page"
set :repo_url, "git@github.com:tsurutan/roubit_landing_page.git"


set :unicorn_pid, -> { "/var/www/roubit_landing_page/shared/pids/unicorn.pid" }
set :unicorn_config_path, "/var/www/roubit_landing_page/current/config/unicorn.rb"

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :confirm do
    on roles(:app) do
      puts "This stage is '#{fetch(:stage)}'. Deploying branch is '#{fetch(:branch)}'."
      puts 'Are you sure? [y/n]'
      ask :answer, 'n'
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      invoke 'deploy'
    end
  end

  task :restart do
    invoke 'unicorn:restart'
  end
  before :starting, :confirm
end
