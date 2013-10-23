node logclient {
}

node 'galt' inherits logclient {

}

node 'atlas' {

  class { "nginx":  }

  nginx::resource::vhost {"www.findamanual.net":
    ensure             => present,
    vhost              => 'www.findamanual.net',
    proxy              => 'vagrant-findamanual',
  }

  nginx::resource::upstream { 'vagrant-findamanual':
    ensure  => present,
    members => [
      '10.0.0.2:80',
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