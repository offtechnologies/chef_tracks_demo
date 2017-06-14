#
# Cookbook:: tracks_demo
# Recipe:: security_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.
###########################################
# Setup and configure basic server security
###########################################

# install basic packages
load = package %w(augeas-tools fail2ban ufw unattended-upgrades) do
  action :install
  options '--no-install-recommends'
end

# edit sshd config
# use i.e augtool if you don't "like" 'sed -re 's/^(PasswordAuthentication)([[:space:]]+)no/\1\2yes/' -i.`date -I` /etc/ssh/sshd_config'
bash 'ssh hardening' do
  user 'root'
  code <<-EOC
    augtool set /files/etc/ssh/sshd_config/PermitRootLogin #{node['security_setup']['RootLogin']}
    augtool set /files/etc/ssh/sshd_config/ChallengeResponseAuthentication #{node['security_setup']['CRAM']}
    augtool set /files/etc/ssh/sshd_config/PasswordAuthentication #{node['security_setup']['PassAuth']}
    augtool set /files/etc/ssh/sshd_config/UsePAM #{node['security_setup']['UsePAM']}
    augtool set /files/etc/ssh/sshd_config/UseDNS #{node['security_setup']['UseDNS']}
    augtool save
  EOC
  only_if { load.updated_by_last_action? }
  notifies :restart, 'service[ssh]', :immediately
end

service 'ssh' do
  action :nothing
end

# configure automatic and daily security updates
template '/etc/apt/apt.conf.d/10periodic' do
  source '10periodic.erb'
  user 'root'
  group 'root'
  mode '0644'
end

# setup minimal firewall rules
bash 'opening ufw for ssh and http traffic' do
  user 'root'
  code <<-EOC
    ufw default deny
    ufw allow 22
    ufw allow 80
    ufw --force enable
  EOC
  only_if { load.updated_by_last_action? }
end
