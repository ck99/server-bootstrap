#! /usr/bin/env bash

# become root
sudo su
mkdir -p /root/.ssh

BOOTSTRAP=/root/.server-bootstrap

mkdir -p /etc/facter/facts.d
echo "ck99_bootstrap=$BOOTSTRAP" > /etc/facter/facts.d/ck99_bootstrap.txt

GITREPO="ck99/server-bootstrap"

apt-get update && apt-get upgrade -y && apt-get install -y git

git config --global user.name "Ciaran Kelly"
git config --global user.email ciaran.kelly@gmail.com
git config --global push.default simple

git clone git://github.com/$GITREPO $BOOTSTRAP

cd $BOOTSTRAP
git remote set-url origin git@github.com:$GITREPO.git
git submodule init
git submodule update

BOOTSTRAP=$BOOTSTRAP $BOOTSTRAP/auth/add-public-keys.sh

# setup hostname
. $BOOTSTRAP/hosts
IP=$(ifconfig | grep -A 1 eth0|grep inet|awk -F: '{print $2}'|awk '{print $1}')
HOSTNAME=${HOSTS["$IP"]}
if [ $HOSTNAME ]
 then
    $BOOTSTRAP/bin/bootstrap-hostname $HOSTNAME

    #install puppet
    $BOOTSTRAP/bin/install-puppet
fi

# config for vagrant VM testbeds
if [ -f /etc/vagrant_box_build_time ]
then
  cd $BOOTSTRAP
  git remote set-url origin https://github.com/${GITREPO}.git
  HOSTNAME=$(hostname)
  FQDN="${HOSTNAME}.vagrant.bitrithm.co.uk"
  UNQDN=$HOSTNAME

  echo $UNQDN > /etc/hostname

  echo "${IP}   ${FQDN}  ${UNQDN}" >> /etc/hosts
  sed --in-place=.backup.bootstrap "s/^127\.0\.0\.1\(\ \)\+\(.*\)/127\.0\.0\.1\ $FQDN\ $UNQDN\ localhost/g" /etc/hosts

  hostname $FQDN

  #install puppet
  $BOOTSTRAP/bin/install-puppet
fi
