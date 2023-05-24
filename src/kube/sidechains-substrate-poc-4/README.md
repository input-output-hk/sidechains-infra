# README.md

## Containers

This environment contains the following stacks:

alice
bob
charlie
dave
eve

## Services

Every container has it's own Service, exposing relevant ports outside of it's Pod. 
Each container can talk to containers in other pods via the following Service hostnames:

http://alice-service:<port>
http://bob-service:<port>
http://charlie-service:<port>
http://dave-service:<port>
http://eve-service:<port>

## Access

For this early stage proof-of-concept environment, access to the Kubernetes cluster can be provided via AWS CloudShell.
The AWS IAM Policy EKS_CloudShell_Access should contain all the neccessary permissions to access a CloudShell environment.
CloudShell will have kubectl available,  authenticated to the EKS cluster.

