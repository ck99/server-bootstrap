#! /usr/bin/env bash

BOOTSTRAP=~/.server-bootstrap

apt-get update && apt-get install -y git

git config --global user.name "Ciaran Kelly"
git config --global user.email ciaran.kelly@gmail.com
git config --global push.default simple

git clone git://github.com/ck99/server-bootstrap $BOOTSTRAP

cd $BOOTSTRAP
git remote set-url origin git@github.com:ck99/server-bootstrap.git

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
