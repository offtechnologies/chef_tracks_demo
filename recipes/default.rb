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
