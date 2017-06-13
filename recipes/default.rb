#
# Cookbook:: tracks_demo
# Recipe:: default
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.

# setup apt and basic packages
include_recipe 'tracks_demo::system_setup'
# setup deployment user
include_recipe 'tracks_demo::user_setup'
# install ruby
include_recipe 'tracks_demo::ruby_setup'
# install postgresql
include_recipe 'tracks_demo::psql_setup'
# install TracksApp's source files
include_recipe 'tracks_demo::source_setup'
# setup TracksApp
include_recipe 'tracks_demo::tracks_setup'
