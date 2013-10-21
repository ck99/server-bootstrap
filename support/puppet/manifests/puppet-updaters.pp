$message = hiera('magic_word')
notify{$message: }

file { '/usr/local/bin/papply':
  source => 'puppet:///modules/bitrithm/papply.sh',
  mode   => '0755',
}

file { '/usr/local/bin/pull-updates':
  source => 'puppet:///modules/bitrithm/pull-updates',
  mode   => '0755',
}

cron {'run-puppet':
  ensure => 'present',
  user => 'root',
  command => '/usr/local/bin/pull-updates',
  minute => '*/10',
  hour => '*',
}