# config valid only for current version of Capistrano
lock "3.8.0"

set :application, "club-reports"
set :repo_url, "git@github.com:juandsierra82/club-reports-api.git"
set :scm, :git


set :branch, "master"
set :puma_threads,    [4, 16]

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/club-reports"
set :use_sudo, true
set :branch, "master"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for :format is :airbrussh.
# set :format, :airbrussh

set :frontend_project_name, "club-reports-frontend"


  namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
  end

  namespace :deploy do
    # make sure we're deploying what we think we're deploying
    before :starting,     :check_revision
    after  :finishing,    :compile_assets_locally
    after  :finishing,    :cleanup
    after  :finishing,    :restart

    desc 'Initial Deploy'
    task :initial do
      on roles(:app) do
        before 'deploy:restart', 'puma:start'
        invoke 'deploy'
      end
    end

    desc 'Restart application'
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        invoke 'puma:restart'
      end
    end
    # only allow a deploy with passing tests to deployed
    #before :deploy, "deploy:run_tests"
    # compile assets locally then rsync
    #after 'finishing', 'deploy:compile_assets_locally'


    # remove the default nginx configuration as it will tend
    # to conflict with our configs.


    # reload nginx to it will pick up any modified vhosts from
    # setup_config


    # Restart monit so it will pick up any monit configurations
    # we've added
   # after 'deploy:setup_config', 'monit:restart'

    # As of Capistrano 3.1, the `deploy:restart` task is not called
    # automatically.

  end
# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
