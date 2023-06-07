# README.md

<!--toc:start-->
- [README.md](#readmemd)
  - [Containers](#containers)
  - [Services](#services)
  - [Access](#access)
<!--toc:end-->

## Containers

This environment contains the following nodes:

alice
bob
charlie
dave
eve

## Services

Every container has its own Service, exposing relevant ports outside its Pod.
Each container can talk to containers in other pods via the following Service hostnames:

http://alice-service:<port>
http://bob-service:<port>
http://charlie-service:<port>
http://dave-service:<port>
http://eve-service:<port>

## Access

For this early stage proof-of-concept environment, access to the Kubernetes cluster can be provided via AWS CloudShell.

The AWS IAM Policy EKS_CloudShell_Access should contain all the necessary permissions to access a CloudShell environment.

CloudShell will have kubectl available, authenticated to the EKS cluster.

## Documentation

The below confluence page contains documentation on the environment:

https://input-output.atlassian.net/wiki/spaces/EMU/pages/3869081650/Sidechains+Substrate+POC+Environment

