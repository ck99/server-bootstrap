#! /usr/bin/env bash

BOOTSTRAP=~/.server-bootstrap

apt-get update && apt-get install -y git

git clone https://github.com/ck99/server-bootstrap $BOOTSTRAP

$BOOTSTRAP/auth/add-public-keys.sh
