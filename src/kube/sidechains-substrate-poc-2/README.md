# README.md

## TODO

bridge-backend - needs grpc to buildkite


## Containers

This environment contains the following service stacks:

alice
bob
charlie
dave
eve

Each stack will contain the following containers:

cardano-node - source of truth
db-sync - reads from cardano-node
postgres - is written to by db-sync
bridge-backend - reads from postgres
substrate-node - reads from bridge-backend
vector - records logs and metrics

As such this is the full list of containers in this environment:

alice-cardano-node
alice-db-sync
alice-postgres
alice-bridge-backend
alice-substrate-node
alice-vector

bob-cardano-node
bob-db-sync
bob-postgres
bob-bridge-backend
bob-substrate-node
bob-vector

charlie-cardano-node
charlie-db-sync
charlie-postgres
charlie-bridge-backend
charlie-substrate-node
charlie-vector

dave-cardano-node
dave-db-sync
dave-postgres
dave-bridge-backend
dave-substrate-node
dave-vector

eve-cardano-node
eve-db-sync
eve-postgres
eve-bridge-backend
eve-substrate-node
eve-vector


## Services

Every container has it's own Service, exposing relevant ports outside of it's Pod. 
Each container can talk to containers in other pods via the following Service hostnames on the respective exposed port number:

http://alice-cardano-node-service
http://alice-db-sync-service
http://alice-postgres-service
http://alice-bridge-backend-service
http://alice-substrate-node-service
http://alice-vector-service

http://bob-cardano-node-service
http://bob-db-sync-service
http://bob-postgres-service
http://bob-bridge-backend-service
http://bob-substrate-node-service
http://bob-vector-service

http://charlie-cardano-node-service
http://charlie-db-sync-service
http://charlie-postgres-service
http://charlie-bridge-backend-service
http://charlie-substrate-node-service
http://charlie-vector-service

http://dave-cardano-node-service
http://dave-db-sync-service
http://dave-postgres-service
http://dave-bridge-backend-service
http://dave-substrate-node-service
http://dave-vector-service

http://eve-cardano-node-service
http://eve-db-sync-service
http://eve-postgres-service
http://eve-bridge-backend-service
http://eve-substrate-node-service
http://eve-vector-service

## Access

For this early stage proof-of-concept environment, access to the Kubernetes cluster can be provided via AWS CloudShell.
The AWS IAM Policy EKS_CloudShell_Access should contain all the neccessary permissions to access a CloudShell environment.
CloudShell will have kubectl available,  authenticated to the EKS cluster.

