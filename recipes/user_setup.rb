#
# Cookbook:: tracks_demo
# Recipe:: user_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.
######################
# deploy user setup
######################

# Load user password from the 'passwords' data bag - located in test/fixtures for local tests - do no use in prod
# run 'openssl passwd -1 yourpasswordhere' in your terminal, copy and paste to user.json
passwords = data_bag_item('passwords', 'user')

# create deploy group
group node['user_setup']['group']

# give group sudo privileges
bash 'setup group sudo privileges' do
  code <<-EOH
    sed -i '/%#{node['user_setup']['group']}.*/d' /etc/sudoers
    echo '%#{node['user_setup']['group']} ALL=(ALL) NOPASSWD:ALL ' >> /etc/sudoers
  EOH
  # grep -x Select only those matches that exactly match the whole line
  # grep -q Quiet; do not write anything to standard output.
  not_if "grep -xq '%#{node['user_setup']['group']} ALL=(ALL) NOPASSWD:ALL ' /etc/sudoers"
end

# create deploy_user
user node['user_setup']['user'] do
  gid node['user_setup']['group']
  home "/home/#{node['user_setup']['user']}"
  password passwords['user_password']
  shell '/bin/bash'
  manage_home true
end
