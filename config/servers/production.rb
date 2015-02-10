namespace :env do
  task :production => [:environment] do
    set :domain,              '188.166.29.213'
    set :user,                'deploy'
    set :deploy_to,           "/home/#{user}/apps/#{app}"
    set :repository,          "git@github.com:opportunato/d4zed"
    set :nginx_path,          '/etc/nginx'
    set :deploy_server,       'production'                   # just a handy name of the server
    set :rails_env,           'production'
    set :branch,              'master'
    invoke :defaults                                         # load rest of the config
  end
end