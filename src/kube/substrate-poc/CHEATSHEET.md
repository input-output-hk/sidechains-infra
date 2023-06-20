# Documentation: 

https://input-output.atlassian.net/wiki/spaces/EMU/pages/3869081650/Sidechains+Substrate+POC+Environment

# Install AWS EFS+EBS Drivers

kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.5"
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.19"

# Setup Local Shell
```
nix-shell -p kubectl awscli2
export AWS_SECRET_ACCESS_KEY=<key>
export AWS_ACCESS_KEY_ID=<key>
export AWS_PROFILE=<profile>
```
# Setup kubectl
```
aws eks update-kubeconfig --region eu-central-1 --name iog-sidechain-substrate-kubernetes
```
# Verify kubectl 
```
aws eks list-clusters --region eu-central-1
kubectl config get-contexts
```
# Deploy pods
```
kubectl apply -f alice.yaml
kubectl apply -f bob.yaml
kubectl apply -f charlie.yaml
kubectl apply -f dave.yaml
kubectl apply -f eve.yaml
```
# Nuke pods
```
kubectl delete -f alice.yaml
kubectl delete -f bob.yaml
kubectl delete -f charlie.yaml
kubectl delete -f dave.yaml
kubectl delete -f eve.yaml
```
# Nuke stacks (including persistent data)
```
kubectl delete -f alice/
kubectl delete -f bob/
kubectl delete -f charlie/
kubectl delete -f dave/
kubectl delete -f eve/
```
# Get Queries
```
kubectl get pods -n sc          # high level summary
kubectl get sc -n sc            # storage classes
kubectl get pvc -n sc           # persistent volume claims
kubectl get pv -n sc            # persistent volumes
kubectl get svc -n sc           # services
kubectl get node -n sc          # nodes
```
# Describe Queries
```
kubectl describe pods -n sc          # detailed summary
kubectl describe sc -n sc            # storage classes
kubectl describe pvc -n sc           # persistent volume claims
kubectl describe pv -n sc            # persistent volumes
kubectl describe svc -n sc           # services
kubectl describe node -n sc          # nodes
```
# Show what node a pod is running on
```
kubectl get pods -o wide -n sc       # full summary

kubectl get pod alice -o jsonpath='{.spec.nodeName}' -n sc
kubectl get pod bob -o jsonpath='{.spec.nodeName}' -n sc
kubectl get pod charlie -o jsonpath='{.spec.nodeName}' -n sc
kubectl get pod dave -o jsonpath='{.spec.nodeName}' -n sc
kubectl get pod eve -o jsonpath='{.spec.nodeName}' -n sc
```
# Logs
```
kubectl logs alice -c cardano-node -n sc
kubectl logs alice -c db-sync -n sc
kubectl logs alice -c postgres -n sc
kubectl logs alice -c bridge-backend -n sc
kubectl logs alice -c substrate-node -n sc
kubectl logs alice -c vector -n sc

kubectl logs bob -c cardano-node -n sc
kubectl logs bob -c db-sync -n sc
kubectl logs bob -c postgres -n sc
kubectl logs bob -c bridge-backend -n sc
kubectl logs bob -c substrate-node -n sc
kubectl logs bob -c vector -n sc

kubectl logs charlie -c cardano-node -n sc
kubectl logs charlie -c db-sync -n sc
kubectl logs charlie -c postgres -n sc
kubectl logs charlie -c bridge-backend -n sc
kubectl logs charlie -c substrate-node -n sc
kubectl logs charlie -c vector -n sc

kubectl logs dave -c cardano-node -n sc
kubectl logs dave -c db-sync -n sc
kubectl logs dave -c postgres -n sc
kubectl logs dave -c bridge-backend -n sc
kubectl logs dave -c substrate-node -n sc
kubectl logs dave -c vector -n sc

kubectl logs eve -c cardano-node -n sc
kubectl logs eve -c db-sync -n sc
kubectl logs eve -c postgres -n sc
kubectl logs eve -c bridge-backend -n sc
kubectl logs eve -c substrate-node -n sc
kubectl logs eve -c vector -n sc
```
# Exec 
```
kubectl exec alice -it -c cardano-node -n sc -- sh
kubectl exec alice -it -c db-sync -n sc -- sh
kubectl exec alice -it -c postgres -n sc -- sh
kubectl exec alice -it -c bridge-backend -n sc -- sh
kubectl exec alice -it -c substrate-node -n sc -- sh
kubectl exec alice -it -c vector -n sc -- sh

kubectl exec bob -it -c cardano-node -n sc -- sh
kubectl exec bob -it -c db-sync -n sc -- sh
kubectl exec bob -it -c postgres -n sc -- sh
kubectl exec bob -it -c bridge-backend -n sc -- sh
kubectl exec bob -it -c substrate-node -n sc -- sh
kubectl exec bob -it -c vector -n sc -- sh

kubectl exec charlie -it -c cardano-node -n sc -- sh
kubectl exec charlie -it -c db-sync -n sc -- sh
kubectl exec charlie -it -c postgres -n sc -- sh
kubectl exec charlie -it -c bridge-backend -n sc -- sh
kubectl exec charlie -it -c substrate-node -n sc -- sh
kubectl exec charlie -it -c vector -n sc -- sh

kubectl exec dave -it -c cardano-node -n sc -- sh
kubectl exec dave -it -c db-sync -n sc -- sh
kubectl exec dave -it -c postgres -n sc -- sh
kubectl exec dave -it -c bridge-backend -n sc -- sh
kubectl exec dave -it -c substrate-node -n sc -- sh
kubectl exec dave -it -c vector -n sc -- sh

kubectl exec eve -it -c cardano-node -n sc -- sh
kubectl exec eve -it -c db-sync -n sc -- sh
kubectl exec eve -it -c postgres -n sc -- sh
kubectl exec eve -it -c bridge-backend -n sc -- sh
kubectl exec eve -it -c substrate-node -n sc -- sh
kubectl exec eve -it -c vector -n sc -- sh
```
# Wipe Persistent Data

1. List all PVCs
```
kubectl get pvc -n sc
```
2. Delete target pod
```
kubectl delete -f <pod_name>.yaml
```

3. Delete target PVC
```
kubectl delete pvc <pvc_name> -n sc
```
4. Recreate PVC
```
kubectl apply -f pvc.yaml
```
5. Recreate pod
```
kubectl apply -f <pod_name>.yaml
```
