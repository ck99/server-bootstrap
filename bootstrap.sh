#! /usr/bin/env bash

BOOTSTRAP=~/.server-bootstrap

apt-get update && apt-get install -y git

git clone git://github.com/ck99/server-bootstrap $BOOTSTRAP

BOOTSTRAP=$BOOTSTRAP $BOOTSTRAP/auth/add-public-keys.sh

export PATH=~/.server-bootstrap/bin:$PATH
