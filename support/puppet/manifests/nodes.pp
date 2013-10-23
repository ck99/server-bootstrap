node logclient {
}

node 'galt' inherits logclient {

}

node 'atlas' {
  class { 'elasticsearch': absent => true}
  class {'logstash': absent => true}
  class { 'kibana':  ensure=>absent}

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