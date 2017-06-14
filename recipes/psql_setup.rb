#
# Cookbook:: tracks_demo
# Recipe:: psql_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.
#################################
# Setup and configure postgresql
#################################

# install packages
new = package 'postgresql'
package 'postgresql-contrib'

# Load root and db user password from the 'passwords' data bag - located in test/fixtures for local tests - do no use in prod
passwords = data_bag_item('passwords', 'psql')

# change password
execute 'change postgresql password' do
  user 'postgres'
  command "psql -c \"alter user postgres with password '#{passwords['root_password']}';\""
  only_if { new.updated_by_last_action? }
end

# create new postgresql admin user
# referenced from http://vladigleba.com/blog/2014/08/12/provisioning-a-rails-server-using-chef-part-2-writing-the-recipes/
execute 'create new postgresql admin' do
  user 'postgres'
  command "psql -c \"create user #{node['psql_setup']['db_admin_name']} with password '#{passwords['admin_password']}';\""
  not_if { `sudo -u postgres psql -tAc \"SELECT * FROM pg_roles WHERE rolname='#{node['psql_setup']['db_admin_name']}'\" | wc -l`.chomp == '1' }
end

# create new TracksApp database
execute 'create new TracksApp database' do
  user 'postgres'
  command "psql -c \"create database #{node['psql_setup']['db_name']} owner #{node['psql_setup']['db_admin_name']};\""
  not_if { `sudo -u postgres psql -tAc \"SELECT * FROM pg_database WHERE datname='#{node['psql_setup']['db_name']}'\" | wc -l`.chomp == '1' }
end
