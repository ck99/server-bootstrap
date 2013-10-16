# add a server instance
  openvpn::server { 'bitrithm':
    country      => 'GB',
    province     => 'SU',
    city         => 'London',
    organization => 'bitrithm.co.uk',
    email        => 'ciaran.kelly@bitrithm.co.uk',
    server       => '10.37.37.0 255.255.255.0'
  }



#sysctl::directive {
#  "net.ipv4.ip_forward":
#    value => 1;
#}
