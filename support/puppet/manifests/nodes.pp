node logclient {
}

node 'galt' inherits logclient {

}

node 'atlas' {
  class { 'elasticsearch': }
  class {'logstash': }
  class { 'kibana':
    webserver   => 'apache',
    virtualhost => 'logs.bitrithm.co.uk', # Default: kibana.${::domain}
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