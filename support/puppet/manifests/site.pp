file { '/usr/local/bin/papply':
  source => 'puppet:///modules/bitrithm/papply.sh',
  mode   => '0755',
}

import 'nodes.pp'

