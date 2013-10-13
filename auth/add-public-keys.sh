#! /bin/bash

KEYDIR="$BOOTSTRAP/ssh-public-keys"

for key in $(ls $KEYDIR)
do
    cat $KEYDIR/$key >> ~/.ssh/authorized_keys
done
