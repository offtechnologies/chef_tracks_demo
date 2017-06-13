#
# Cookbook:: tracks_demo
# Recipe:: runit_setup
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#################################
# Setup and configure runit
#################################
release_dir     = node['source_setup']['dest_dir']
service_name    = node['source_setup']['service_name']
runit_command   = 'bundle exec rails server -e production'
deploy_user     = node['user_setup']['user']
deploy_group    = node['user_setup']['group']

# install standard runit packages
package 'runit'

# create directories for runit scripts
directory "/etc/sv/#{service_name}/log" do
  mode '0755'
  owner deploy_user
  group deploy_group
  action :create
  recursive true
end

# update service template
template "/etc/sv/#{service_name}/run" do
  source 'run_tracks_app.erb'
  mode '0755'
  variables(
    release_dir: release_dir,
    deploy_user: deploy_user,
    runit_command: runit_command
  )
end

# update service log template
template "/etc/sv/#{service_name}/log/run" do
  source 'run_tracks_log.erb'
  mode '0755'
  variables(
    service_name: service_name
  )
end

# create directories for runit scripts
directory "/var/log/#{service_name}" do
  mode '0755'
  owner deploy_user
  group deploy_group
  action :create
  recursive true
end

# create symbolic link
link "/etc/service/#{service_name}" do
  to "/etc/sv/#{service_name}"
  link_type :symbolic
  action :create
end
