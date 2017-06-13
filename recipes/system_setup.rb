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

# install basic pakages
package %w(build-essential libpq-dev zlib1g zlib1g-dev libmysqlclient-dev libsqlite3-dev libgmp3-dev) do
  action :install
  options '--no-install-recommends'
end

# timezone setup
bash 'set timezone' do
  code <<-EOH
    echo #{node['system_setup']['timezone']} > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
  EOH
  not_if "date | grep -q 'CEST'"
end
