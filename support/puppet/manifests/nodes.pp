node 'galt' {
  file {'/tmp/hello':
    ensure => absent,
  }

  file {'/tmp/hellosdsd':
    content => "hi, this is cool",
  }
}