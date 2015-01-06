set :stages, %w(production)
set :default_stage, "production"
require 'capistrano/ext/multistage'
require "bundler/capistrano"
require "rvm/capistrano"
#load "lib/deploy/seed" #used for seeding the db

set :user, "christianhofer"
set :rvm_type, :system
set :rvm_ruby_string, 'ruby-2.0.0-p598'

set :adapter, "mysql2"
set :socket, "none"

set :scm, "git"
set :repository,  "https://github.com/homebase-dev/Clever.git"

["base", "rails", "nginx", "logrotate"].each { |recipe| 
  load(File.join("config", "deploy", "setup", recipe)) 
}
