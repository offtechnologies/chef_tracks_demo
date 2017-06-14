#
# Cookbook:: tracks_demo
# Recipe:: tracks_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.

#################################
# Setup and configure TracksApp
#################################

release_dir     = node['source_setup']['dest_dir']
home_dir        = "/home/#{node['user_setup']['user']}"
deploy_user     = node['user_setup']['user']
excluded_groups = %w(development test)
passwords       = data_bag_item('passwords', 'psql')
db_adapter      = node['tracks_setup']['db_adapter']
db_name         = node['psql_setup']['db_name']
db_encoding     = node['tracks_setup']['db_encoding']
db_host         = node['tracks_setup']['db_host']
db_admin_name   = node['psql_setup']['db_admin_name']
token           = data_bag_item('passwords', 'token')
timezone        = node['system_setup']['timezone']

# if postgresql is used I need to edit TracksApp Gemfile and add gem "pg", "~> 0.20.0" and gem "childprocess", "~> 0.5.5"
load = template "#{release_dir}/Gemfile" do
  source 'Gemfile.erb'
  mode '0755'
end

# if postgresql is used I need this to avoid Gemfile.lock error - for local tests only - do no use in prod
bash 'boundle install' do
  cwd release_dir
  user deploy_user
  environment 'HOME' => home_dir
  code <<-EOH
    /usr/local/bin/bundle install --quiet --no-deployment
    /usr/local/bin/bundle install --quiet --deployment --without #{excluded_groups.join(' ')}
  EOH
  # guard_command = '/usr/local/bin/bundle check, cwd: release_dir, user: deploy_user'
  # Chef::Log.warn "Guard command is: `#{guard_command}`"
  only_if { load.updated_by_last_action? }
end

# update database.yml template
template "#{release_dir}/config/database.yml" do
  source 'database.yml.erb'
  mode '0755'
  variables(
    adapter: db_adapter,
    database: db_name,
    encoding: db_encoding,
    host: db_host,
    username: db_admin_name,
    password: passwords['admin_password']
  )
end

# update site.yml
template "#{release_dir}/config/site.yml" do
  source 'site.yml.erb'
  mode '0755'
  variables(
    secret_token: token['token_value'],
    time_zone: timezone
  )
end

# migration and assets
bash 'migration' do
  cwd release_dir
  user deploy_user
  environment 'HOME' => home_dir
  code <<-EOH
    /usr/local/bin/bundle exec rake db:migrate RAILS_ENV=production
    /usr/local/bin/bundle exec rake assets:precompile RAILS_ENV=production
  EOH
  only_if { load.updated_by_last_action? }
end
