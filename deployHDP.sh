#!/bin/bash -x
# Setup Provisioning for a server
# cat ~/.ssh/id_dsa.pub | ssh you@remote 'cat - >> ~/.ssh/authorized_keys'
ssh root@$1 ssh-keygen
cat ~/.ssh/id_rsa.pub | ssh root@$1 'cat - >> ~/.ssh/authorized_keys'
echo "After host SSH setup"
ssh root@server1 "cat ~/.ssh/id_rsa.pub" | ssh root@$1 'cat - >> ~/.ssh/authorized_keys'
echo "After server 1 ssh setup"
ssh root@$1 'chmod 600 ~/.ssh/authorized_keys'
echo "After permission set"
#scp ~/provisionCluster/provisionAmbariServer.sh root@$1:~
#scp hosts root@$1:/etc/hosts
#ssh root@$1 'bash -s' < provisionAmbariServer.sh
