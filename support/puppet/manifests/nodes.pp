node 'galt' {
  file {'/tmp/hello':
    content => "Hello World!",
  }
}