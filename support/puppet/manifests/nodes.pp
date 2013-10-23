node logclient {
}

node 'galt' inherits logclient {

}

node 'atlas' {

  class { "nginx":  }

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

node /findamanual.vagrant/ inherits logclient {

  apache::vhost { 'default':
    docroot             => '/var/www',
    server_name         => false,
    priority            => '',
    template            => 'apache/virtualhost/vhost.conf.erb',
  }

  class {'php': }
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