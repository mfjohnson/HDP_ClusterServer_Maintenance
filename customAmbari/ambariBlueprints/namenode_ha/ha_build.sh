ansible-playbook  ../../../cleanup/killOrphanedHDP.yml
ansible all -a "pkill python"
ansible-playbook  ../../../cleanup/uninstallHDP.yml
ansible-playbook  ../../../cleanup/provisionHDP.yml

#./ha_buildCluster.sh