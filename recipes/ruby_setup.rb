#
# Cookbook:: tracks_demo
# Recipe:: ruby_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.
##############################
# Install Ruby
##############################

# Adds the Brightbox repo for Ruby
apt_repository 'brightbox-ruby-ppa' do
  uri 'ppa:brightbox/ruby-ng'
  distribution node['lsb']['codename']
  components ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C3173AA6'
end

# Install ruby from brightbox-ruby-ppa
package "ruby#{node['ruby_setup']['ruby_version']}" do
  action :upgrade
end

# install ruby-dev needed for bundler
package "ruby#{node['ruby_setup']['ruby_version']}-dev" do
  action :upgrade
end

# Install bundler
gem_package 'bundler' do
  gem_binary '/usr/bin/gem'
  action :upgrade
end
