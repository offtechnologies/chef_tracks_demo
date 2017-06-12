#
# Cookbook:: tracks_demo
# Recipe:: system_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.
##############################
# Setup apt and basic packages
##############################

# update apt cache daily
apt_update 'daily' do
  frequency 86_400
  action :periodic
end
