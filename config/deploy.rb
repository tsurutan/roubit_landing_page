lock "3.7.0"

set :application, "roubit_landing_page"
set :repo_url, "git@github.com:tsurutan/roubit_landing_page.git"


set :unicorn_pid, -> { "/var/www/roubit_landing_page/shared/pids/unicorn.pid" }
set :unicorn_config_path, "/var/www/roubit_landing_page/current/config/unicorn.rb"

set :branch, ENV['BRANCH'] || 'master'
set :pty, true # タスク内でsudoするために必要

set :rbenv_type, :user # :system or :user
set :rbenv_path, '/usr/local/rbenv'
set :rbenv_ruby, '2.3.0'
set :rbenv_prefix, "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all # default value

# Rails の設定 see: https://github.com/capistrano/rails/
set :rails_env, 'production'

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

  # task :restart do
  #   on roles(:app) do
  #     execute 'cd /var/www/roubit_landing_page/current ; bundle install'
  #   end
  # end
  before :starting, :confirm
end
