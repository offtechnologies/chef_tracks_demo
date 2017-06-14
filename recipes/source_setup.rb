#
# Cookbook:: tracks_demo
# Recipe:: source_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.

######################################
# Setup and configure TracksApp source
######################################

# v2.3.0.tar.gz
source_filename_tar = "#{node['source_setup']['file_name']}#{node['source_setup']['file_version']}.tar.gz"

# https://github.com/TracksApp/tracks/archive/v2.3.0.tar.gz
source_url = "#{node['source_setup']['url']}/#{source_filename_tar}"

# i.e. /srv/tracks_demo
dest_path = node['source_setup']['dest_dir']

# creates destination dir for TracksApp
directory dest_path do
  owner node['user_setup']['user']
  group node['user_setup']['group']
  mode '0755'
  action :create
end

# downloads tar file from github
load = execute 'download TracksApp tar file' do
  user node['user_setup']['user']
  group node['user_setup']['group']
  cwd dest_path
  command <<-EOH
    wget #{source_url}
  EOH
  creates source_filename_tar
end

# extracts tar
execute 'extract_TracksApp' do
  cwd dest_path
  user node['user_setup']['user']
  group node['user_setup']['group']
  command <<-EOH
    tar xzf #{source_filename_tar} --directory #{dest_path}
    mv #{dest_path}/*/* #{dest_path}/
  EOH
  only_if { load.updated_by_last_action? }
end
