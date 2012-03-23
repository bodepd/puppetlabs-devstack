# == Class: devstack
#
# Class that uses devstack to deploy
# development instances of openstack
#
# == Authors
#
#  Dan Bode bodepd@gmail.com
#
# == Copyright
#  Copyright 2012 PuppetLabs
#
class devstack(
  $admin_password = 'password',
  $mysql_password = 'password',
  $rabbit_password = 'password',
  $service_token = 'service_token',
  $flat_interface = 'br100',
  $git_protocol   = 'https'
) {

  require git

  package { 'screen': }

  vcsrepo { '/var/lib/devstack':
    ensure   => 'present',
    source   => "${git_protocol}://github.com/cloudbuilders/devstack.git",
    provider => 'git',
    require  => Class['git'],
  }

  #user { 'stack':
  #  ensure => present,
  #}

  file { '/var/lib/devstack/localrc':
    content => template('devstack/localrc.erb'),
    mode => 777,
    require => Vcsrepo['/var/lib/devstack'],
  }

  #exec { 'run_devstack':
  #  command     => '/var/lib/devstack/stack.sh',
  #  user        => 'stack',
  #  cwd         => '/var/lib/devstack',
  #  refreshonly => false,
  #  require     => File['/var/lib/devstack/localrc'],
  #  subscribe   => Vcsrepo['/var/lib/devstack'],
  #}


  # annoying manual steps
  # 1. cp /opt/stack/nova/bin/nova.conf /etc/nova/nova.conf
  # 2. set up a route to the private network
  # 3. set up firewall rules to forward to that address (icmp and tcp)
  # 4. set up default group
}
