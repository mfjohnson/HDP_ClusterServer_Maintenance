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
