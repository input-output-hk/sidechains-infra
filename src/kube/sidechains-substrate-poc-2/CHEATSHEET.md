# CHEATSHEET

## Local
nix-shell -p kubectl awscli2 kubernetes-helm

## List
helm list

## Deploy
helm install <version> ./ --namespace sidechains-substrate-poc-2

## High level
kubectl get pods -n sidechains-substrate-poc # List containers
kubectl get secrets -n sidechains-substrate-poc # Show secrets
kubectl get configmaps -n sidechains-substrate-poc
kubectl get services -n sidechains-substrate-poc

## View Container Logs
kubectl logs alice -c alice -n sidechains-substrate-poc
kubectl logs bob -c bob -n sidechains-substrate-poc
kubectl logs charlie -c charlie -n sidechains-substrate-poc
kubectl logs dave -c dave -n sidechains-substrate-poc
kubectl logs eve -c eve -n sidechains-substrate-poc

## Enter Container Shell
kubectl exec -it -n sidechains-substrate-poc alice -- sh
kubectl exec -it -n sidechains-substrate-poc bob -- sh
kubectl exec -it -n sidechains-substrate-poc charlie -- sh
kubectl exec -it -n sidechains-substrate-poc dave -- sh
kubectl exec -it -n sidechains-substrate-poc eve -- sh
kubectl exec -it -n sidechains-substrate-poc cardano-node -- sh
kubectl exec -it -n sidechains-substrate-poc db-sync -- sh
kubectl exec -it -n sidechains-substrate-poc bridge-backend -- sh
kubectl exec -it -n sidechains-substrate-poc vector -- sh
kubectl exec -it -n sidechains-substrate-poc postgres -- sh

## Deploy
kubectl apply -f environment.yaml

## Nuke
kubectl delete all --all -n sidechains-substrate-poc-2
