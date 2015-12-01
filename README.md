# HDP ClusterServer Maintenance Overview
The project scripts enable both a server provisioning in preparation of a HDP installation as well as a complete wipe of an existing HDP instance to support a reinstallation.  The project consists of both shell and ansible scripts.

# Configure Ansible for use with the following playbooks
## Pre-conditions
   - Ansible is installed
   - All target cluster servers are imaged with the OS
## How to steps:
   - modify the ansible 'hosts' file and install in your host direct /usr/local/etc/ansible directory.  See the example 'hosts' directory in this repository.

# Configure password less SSH
For Ambari it is necessary to have password less access from the Ambari server to each of the cluster member nodes.  It is also handy to have your laptop/host also with password-less.  Executing the following shell script will setup this functionality.

# Provision servers in preparation for a HDP installation
## Pre-conditions
   - Server(s) are imaged with a linux OS
   - Ansible is installed and the user has a basic understanding of this fine tool.
   - Establish password-less SSH
   - If the server is not a fresh instance, it is a good idea to first tear down the HDP installation using the uninstallHDP.yml playbook.
   
## How to steps
   - Define Ansible 'hosts' file for all of your servers.  Specify one of the servers as belonging to the 'ambari' group.  This server will be the location of the Ambari-server instance.  All servers shoudl go to the all group.
   - Setup password less SSH XXXX
   - execute the command 'ansible-playbook provisionHDP.yml'.  This playbook will setup all the requisite utilities, and will install Ambari-server using the default users and databases.  If you wish something different, change the last couple of tasks within this playbook file.
   - Access the Ambari-server UI by accessing the web page 'http://{your ambari server FQN}:8080'


# Tear down HDP installation
## Pre-conditions
   - Server(s) are imaged with a linux OS
   - Ansible is installed and the user has a basic understanding of this fine tool.
   - Establish password-less SSH
   - An instance of HDP has been installed already once.

Note:  This script does not attempt backup metadata.

## How to steps:
   - leverage existing Ansible 'hosts' file used in the above step.  Specify one of the servers as belonging to the 'ambari' group.  This server will be the location of the Ambari-server instance.  All servers shoudl go to the all group.
   - Execute the command 'ansible-playbook uninstallHDP.yml'.  This playbook will assure that all the components setup as part of the provision are 'absent' from all the cluster nodes.

# Configure Oracle for Ambari, Hive and Oozie Metastore Usage
For enterprise HDP users with deep skills in Oracle and who do not want to use the standard HDP metstore definitions
## Playbook name: OracleAmbariConfiguration.yml
## Pre-conditions
   - An instance of Oracle is already installed and running when the playbook is run.
   - The provisionHDP.yml playbook has already run successfully and that ambari-server setup has not yet been run.  Make certain to verify that the provisionHDP.yml playbook has the ambari-server setup play commented out.
   - A 'oracle' Ansible Host is defined with a single server definition
   - password less ssh is defined for the oracle user

## How to steps:
   - Confirm the vars within the playbook are as desired
   - run the playbook: 'ansible-playbook OracleAmbariConfiguration.yml'


---- In progress source notes
- [ ] ansible-playbook uninstallHDP.yml
- [ ] reboot all servers ( ansible all -a "/sbin/reboot" -f 10 -u root)
- [x] ansible-playbook provisionHDP.yml
- [ ] Make certain the Oracle SYSTEM user, hive user, admin and oozie users exists from server1
- [ ] sqlplus admin/admin @/var/lib/ambari-server/resources/Ambari-DDL-Oracle-DROP.sql
- [ ] ‘ambari-server setup’ and then enter parameters…do not use silent mode
    - use all defaults until advanced database
        - Option #2 - Oracle
        - hostname: server1.hdp
        - port:1521
        - Identifier type - (2- SID) - XE
        - username: admin
        - password: admin
        - Not CREATE message (next step) and agree to finish configuring remote database connection
        - Double check etc/ambari-server/conf/ambari.properties to config jdbc properties are correctly set.
- [x] sqlplus admin/admin @/var/lib/ambari-server/resources/Ambari-DDL-Oracle-CREATE.sql
    - Note: a bunch of the qrtz tables will be reported as not existing
- [ ] ambari-server start.  Verify ambari-server reported as ‘start’ completed successfully"
- [ ] Setup cluster using Ambari (server1:8080) workflow and use initial defaults.  Setup the following users
    - SID=XE
    - Hive user: hive/hive
    - host=server1.hdp

Upgrade from the 1.6.1 Oracle to 2.0.2:

- turn off all occurrences of ambari-server and ambari-agent
    - ansible all -a "ambari-server stop" -f 10 -u root
    - ansible all -a "ambari-agent stop" -f 10 -u root
    - reboot servers
- Retrieve ambari.repo: wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.0.2/ambari.repo -O /etc/yum.repos.d/ambari.repo
- yum clean all
