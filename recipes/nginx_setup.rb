#
# Cookbook:: tracks_demo
# Recipe:: nginx_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.

#########################################
# Setup and configure nginx reverse proxy
#########################################

site         = node['source_setup']['service_name']
root_dir     = "#{node['source_setup']['dest_dir']}/public"
deploy_user  = node['user_setup']['user']
deploy_group = node['user_setup']['group']
default_path = '/etc/nginx/sites-enabled/default'

# install standart package
package 'nginx'

# delete default
file default_path do
  action :delete
end
# execute 'rm -f #{default_path}' do
#  only_if { File.exists?(default_path) }
# end

# start nginx service
service 'nginx' do
  supports [:status, :restart]
  action :start
end

# add new nginx config from template and restart nginx
template "/etc/nginx/sites-enabled/#{site}" do
  source 'nginx.conf.erb'
  mode 0644
  owner deploy_user
  group deploy_group
  variables(
    site: site,
    root_dir: root_dir
  )
  notifies :restart, 'service[nginx]', :delayed
end
