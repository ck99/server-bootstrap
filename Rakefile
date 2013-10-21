require 'open3'
desc "Clear SSH known hosts entry for ENV['HOST']"
task :clear_ssh_cache => [:get_hostname] do
  hostname=ENV['HOST']
  ip_address=%x[dig +short #{hostname}]
  ip_address.rstrip!
  puts "Clearing known hosts entries for #{hostname} (#{ip_address})"
  Open3.popen3("ssh-keygen -f ~/.ssh/known_hosts -R #{ip_address}"){|i,o,e,t|
    o.read.chomp #=> "/"
    e.read.chomp #=> "/"
  }
  Open3.popen3("ssh-keygen -f ~/.ssh/known_hosts -R #{hostname}")   {|i,o,e,t|
    o.read.chomp #=> "/"
    e.read.chomp #=> "/"
  }
  puts "done."
end

desc "Copy public key to server for passwordless login"
task :copy_public_key => [:get_hostname, :get_credentials] do
  hostname=ENV['HOST']
  user=ENV['USERNAME']||'root'
  password=ENV['PASSWORD']
  keyfile=ENV['KEYFILE']
  puts "Copying #{keyfile} to #{hostname}"
  wd=`pwd`
  wd.rstrip!
  Open3.popen3("#{wd}/bootstrap/copy-public-key #{user} #{password} #{hostname} #{keyfile}")    {|i,o,e,t|
    p o.read.chomp #=> "/"
    p e.read.chomp #=> "/"
  }
end

desc "Bootstrap server"
task :bootstrap => [:clear_ssh_cache, :copy_public_key] do
  hostname=ENV['HOST']
  puts "#{hostname} bootstrapped"
end

desc "Run bootstrap"
task :run_bootstrap do
  hostname=ENV['HOST']
  user=ENV['USERNAME']||'root'
  wd=`pwd`
  wd.rstrip!
  puts "#{wd}/bootstrap/run-bootstrap #{user} #{hostname}"
  Open3.popen3("#{wd}/bootstrap/run-bootstrap #{user} #{hostname}")    {|i,o,e,t|
    p o.read.chomp #=> "/"
    p e.read.chomp #=> "/"
  }
end

desc "Require Hostname"
task :get_hostname do
  unless ENV['HOST']
    input = ''
    STDOUT.puts "What is the hostname of the server you want to bootstrap?"
    ENV['HOST'] = STDIN.gets.chomp
  end
end

desc "Require Credentials"
task :get_credentials do
  unless ENV['USERNAME']
    input = ''
    STDOUT.puts "What is the username for the host you want to bootstrap?"
    ENV['USERNAME'] = STDIN.gets.chomp
  end
  unless ENV['PASSWORD']
    input = ''
    STDOUT.puts "What is the password for the host you want to bootstrap?"
    ENV['PASSWORD'] = STDIN.gets.chomp
  end
end