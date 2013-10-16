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

export PATH=~/.server-bootstrap/bin:$PATH
