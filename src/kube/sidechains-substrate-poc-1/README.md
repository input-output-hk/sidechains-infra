# README.md

## Containers

This environment contains the following containers:

alice
bob
charlie
dave
eve
db-sync
vector
bridge-backend
postgres
cardano-node

## Services

Every container has it's own Service, exposing relevant ports outside of it's Pod. 
Each container can talk to containers in other pods via the following Service hostnames:

http://alice-service:<port>
http://bob-service:<port>
http://charlie-service:<port>
http://dave-service:<port>
http://eve-service:<port>
http://db-sync-service:<port>
http://vector-service:<port>
http://bridge-backend-service:<port>
http://postgres-service:<port>
http://cardano-node-service:<port>

## Access

For this early stage proof-of-concept environment, access to the Kubernetes cluster can be provided via AWS CloudShell.
The AWS IAM Policy EKS_CloudShell_Access should contain all the neccessary permissions to access a CloudShell environment.
CloudShell will have kubectl available,  authenticated to the EKS cluster.

