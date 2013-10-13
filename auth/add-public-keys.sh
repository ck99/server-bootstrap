#! /bin/bash

KEYDIR="ssh-public-keys"

for key in $(ls $KEYDIR)
do
    cat $key >> ~/.ssh/authorized_keys
done
