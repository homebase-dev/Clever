set :rails_env, "production"
set :branch, "master"
set :application, "www.aufnahmetest.at"
set :server_names, [{ :name => "www.aufnahmetest.at"}]
set :ssl_host, "www.aufnahmetest.at"

role :app, "www.aufnahmetest.at"
role :web, "www.aufnahmetest.at"
role :db,  "www.aufnahmetest.at", :primary => true
set :deploy_to, "/var/www/#{application}"

# application setup
set :ip, "80.120.121.245"
set :db_host, "mysql.antiloop.com"
set :db_prefix, "aufnahmetest"
set :db_username, "christianhofer"
set :db_password, "Shefbiess"

# ssl settings
set :ssl, false

after "deploy:setup", "nginx:setup"
after "deploy:cold", "nginx:symlink"
after "deploy:cold", "nginx:reload"
