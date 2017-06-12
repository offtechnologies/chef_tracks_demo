# username and group
default['user_setup']['user']            = 'tracks_admin'
default['user_setup']['group']           = 'tracks_admin'

# ruby_setup
default['ruby_setup']['ruby_version']    = '2.1'

# postgresql setup
default['psql_setup']['db_name']         = 'tracks'
default['psql_setup']['db_admin_name']   = 'tracks'

# source_setup
default['source_setup']['url']           = 'https://github.com/TracksApp/tracks/archive'
default['source_setup']['file_name']     = 'v'
default['source_setup']['file_version']  = '2.3.0'
default['source_setup']['service_name']  = 'tracks_demo'
default['source_setup']['dest_dir']      = "/srv/#{node['source_setup']['service_name']}"
