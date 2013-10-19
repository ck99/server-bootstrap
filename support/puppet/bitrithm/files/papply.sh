#! /bin/bash

cd /etc/puppet
sudo librarian-puppet install
sudo puppet apply /etc/puppet/manifests/site.pp