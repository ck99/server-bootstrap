node 'galt' {
class { "nginx":  }
class {'mysql':
  root_password => 'auto',
  }

class { "redis": }

  mysql::grant { 'gitlab':
    mysql_privileges => 'ALL',
    mysql_password => 'gitlab',
    mysql_db => 'gitlab',
    mysql_user => 'gitlab',
    mysql_host => 'localhost',
  }

  class {
    'gitlab':
    git_email         => 'ciaran.kelly@gmail.com',
    git_comment       => 'GitLab',
    gitlab_domain     => 'git.bitrithm.co.uk',
    gitlab_dbtype     => 'mysql',
    gitlab_dbname     => 'gitlab',
    gitlab_dbuser     => 'gitlab',
    gitlab_dbpwd      => 'gitlab',
    ldap_enabled      => false,
  }
}

node 'atlas' {

  file {'/var/shared_data':
    ensure=>directory,
    owner => 'root',
    group => 'root',
  }

  file {'/var/shared_data/des':
    ensure=>directory,
    owner => 'des',
    group => 'root',
  }


  file {'/var/shared_data/des/public_html':
    ensure=>directory,
    owner => 'des',
  }

  group { "sftpusers":
    ensure => "present",
  }

  user { 'des':
    ensure   => 'present',
    password => '$6$febeegie$rVyEvM8keOBZdHSADibxxLSl40326PiFveVntR5PKFNWaHKKaQucos1mjyzL1vLcz4JrI5TlbdI5K0foQjCUW0',
    groups   => ['sftpusers'],
    home     => '/var/shared_data/des',
    shell    => '/bin/false',
  }

  sshd_config_subsystem { "sftp":
    ensure  => present,
    command => "internal-sftp",
  }

  sshd_config { "ChrootDirectory":
    ensure    => present,
    condition => "Group sftpusers",
    value     => "/var/shared_data",
  }

  sshd_config { "ForceCommand":
    ensure    => present,
    condition => "Group sftpusers",
    value     => "internal-sftp",
  }

  sshd_config { "AllowTCPForwarding":
    ensure    => present,
    condition => "Group sftpusers",
    value     => "no",
  }

  package {'g++' : ensure => installed}

  class { "nginx":  }

  class {'mysql':
    root_password => 'auto',
  }

  class { "redis": }

  mysql::grant { 'gitlab':
    mysql_privileges => 'ALL',
    mysql_password => 'gitlab',
    mysql_db => 'gitlab',
    mysql_user => 'gitlab',
    mysql_host => 'localhost',
  }

  class {
    'gitlab':
    git_email         => 'ciaran.kelly@gmail.com',
    git_comment       => 'GitLab',
    gitlab_domain     => 'git.bitrithm.co.uk',
    gitlab_dbtype     => 'mysql',
    gitlab_dbname     => 'gitlab',
    gitlab_dbuser     => 'gitlab',
    gitlab_dbpwd      => 'gitlab',
    ldap_enabled      => false,
  }

  Class['gitlab'] ~> Service['nginx']

  nginx::resource::vhost {"www.mpce.eu":
    ensure             => present,
    proxy              => 'http://vagrant-findamanual',
  }

  nginx::resource::vhost {"mpce.eu":
    ensure             => present,
    proxy              => 'http://vagrant-findamanual',
  }

  nginx::resource::vhost {"www.findamanual.net":
    ensure             => present,
    proxy              => 'http://vagrant-findamanual',
  }

  nginx::resource::upstream { 'vagrant-findamanual':
    ensure  => present,
    members => [
      '10.0.0.4:80',
    ],
  }

  openvpn::server { 'bitrithm':
    country      => 'GB',
    province     => 'SU',
    city         => 'London',
    organization => 'bitrithm.co.uk',
    email        => 'ciaran.kelly@bitrithm.co.uk',
    server       => '10.37.37.0 255.255.255.0'
  }

  openvpn::client { 'ciaran-laptop':
    server => 'bitrithm'
  }

  openvpn::client_specific_config { 'ciaran-laptop':
    server => 'bitrithm',
    ifconfig => '10.37.37.37 10.37.37.38'
  }
}

node /findamanual.vagrant/ {
  include apache

  apache::vhost { 'default':
    docroot             => '/var/www',
    server_name         => false,
    priority            => '',
    template            => 'apache/virtualhost/vhost.conf.erb',
  }

  class {'php': }
  php::module { 'mysql': }
  class {'mysql':
    root_password => 'auto',
  }

  mysql::grant { 'findamanual':
    mysql_privileges => 'ALL',
    mysql_password => 'password',
    mysql_db => 'findamanual',
    mysql_user => 'findamanual',
    mysql_host => 'localhost',
  }

}