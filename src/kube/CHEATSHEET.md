# CHEATSHEET

## Local
aws eks update-kubeconfig --region eu-central-1 --name  iog-sidechain-substrate-kubernetes
aws ecr get-login-password --region eu-central-1
aws eks list-clusters --region eu-central-1
nix-shell -p kubectl awscli2
kubectl config get-contexts

## High level
kubectl get pods -n sidechains-substrate-poc # List containers
kubectl get secrets -n sidechains-substrate-poc # Show secrets
kubectl describe statefulset sidechains-substrate-poc -n sidechains-substrate-poc # Inspect the statefulset
kubectl describe pod sidechains-substrate-poc-0 -n sidechains-substrate-poc # Inspect the pod

## View container logs
kubectl logs sidechains-substrate-poc-0 -c substrate-node -n sidechains-substrate-poc
kubectl logs sidechains-substrate-poc-0 -c cardano-node -n sidechains-substrate-poc
kubectl logs sidechains-substrate-poc-0 -c postgres -n sidechains-substrate-poc
kubectl logs sidechains-substrate-poc-0 -c vector -n sidechains-substrate-poc
kubectl logs sidechains-substrate-poc-0 -c bridge-backend -n sidechains-substrate-poc
kubectl logs sidechains-substrate-poc-0 -c cardano-db-sync -n sidechains-substrate-poc

## Deploy
kubectl apply -f megapod.yaml

## Nuke
kubectl delete statefulset sidechains-substrate-poc -n sidechains-substrate-poc
