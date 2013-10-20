node 'raring64-vanilla.vagrant' inherits logclient {
  class { 'kibana':
    webserver   => 'apache',
    virtualhost => 'logs.bitrithm.co.uk', # Default: kibana.${::domain}
  }
}