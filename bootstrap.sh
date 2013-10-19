#! /usr/bin/env bash

BOOTSTRAP=/root/.server-bootstrap
GITREPO="ck99/server-bootstrap"

apt-get update && apt-get upgrade -y && apt-get install -y git

git config --global user.name "Ciaran Kelly"
git config --global user.email ciaran.kelly@gmail.com
git config --global push.default simple

git clone git://github.com/$GITREPO $BOOTSTRAP

cd $BOOTSTRAP
git remote set-url origin git@github.com:$GITREPO.git

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
