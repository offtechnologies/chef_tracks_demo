# tracks_demo
##### This is experimental stuff - Do not use in production!
Tracks_demo is my Chef cookbook with recipes needed to deploy Tracks (Ruby on Rails) application to a server running Ubuntu 14.04. Tracks is a web-based application to help you implement David Allen’s Getting Things Done™ methodology. To learn more on Tracks please visit [this website][tracks]
#### 1.0 - 2017-06-14
* Initial commit
*  latest stable release of Tracks (v2.3.0)
*  Ruby 2.1  - Tracks requires Ruby 1.9.3 or greater but gem install json -v 1.8.3 fails if ruby -v is greater then 2.1 ....
*  PostgreSQL - was not supported by default … needs new Gemfile.lock
*  WEBrick via runit
*  Nginx reverse proxy in front of the Rails app
*  basic ufw and ssh hardening
#### Requirements
* Chef Development Kit Version: 1.4.3
* Chef-client version: 12.19.36
* berks version: 5.6.4
* kitchen version: 1.16.0
* inspec version: 1.25.1
* Vagrant 1.8.5
#### Usage
    git clone https://github.com/offtechnologies/chef_tracks_demo
    cd chef_tracks_demo
    kitchen converge

[tracks]:<http://www.getontracks.org/>
