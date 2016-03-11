# Provision cluster using Ambari blueprints
# MAKE CERTAIN THE CLUSTER $CLUSTER_NAME DOES NOT ALREADY EXIST
#ssh root@server1 'ambari-server start'
#sleep 30
export HOST_NAME="server1.hdp"
export CLUSTER_NAME="HDP"
export BLUEPRINT="yarn_ha_blueprint"
export HOST_MAPPING="yarn_rm_cluster_template"

echo " GET http://$HOST_NAME:8080/api/v1/hosts > hostList.json"
echo "Retrieving active host list"
curl -u admin:admin -H "X-Requested-by:ambari" -i -k -X GET http://$HOST_NAME:8080/api/v1/hosts > hostList.json
echo "Retrieving registered blueprints"
curl -u admin:admin -H "X-Requested-by:ambari" -i -k -X GET http://$HOST_NAME:8080/api/v1/blueprints > registeredBlueprints.json
echo "Registering the blueprint"
curl -u admin:admin -i -H "X-Requested-By:ambari" -X POST -d @$BLUEPRINT.json http://$HOST_NAME:8080/api/v1/blueprints/$BLUEPRINT 
echo "Creating the cluster"
curl -u admin:admin -i -H "X-Requested-By:ambari" -X POST -d @$HOST_MAPPING.json http://$HOST_NAME:8080/api/v1/clusters/$CLUSTER_NAME

