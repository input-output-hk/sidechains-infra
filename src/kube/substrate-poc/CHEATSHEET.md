# Documentation: 

https://input-output.atlassian.net/wiki/spaces/EMU/pages/3869081650/Sidechains+Substrate+POC+Environment

# Install AWS EFS+EBS Drivers
```
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.5"
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.19"
```
# Label Nodes

Stacks are assigned to nodes via labels, in the order they are displayed in the `kubectl get nodes' command. 
The following commands will label the nodes in the cluster.
```
kubectl label nodes <node> pod=<pod>
```
The bash script below can label the nodes correctly:
```
src/kube/substrate-poc/environments/label-nodes.sh
```
Labels can be verified with:
```
kubectl get nodes -o json | jq -r '.items[] | {name: .metadata.name, pod: .metadata.labels.pod}'
```
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
# View all pods in all namespaces
```
kubectl get pods --all-namespaces -o wide
```
# Deploy pods
```
kubectl apply -f alice/alice.yaml
kubectl apply -f bob/bob.yaml
kubectl apply -f charlie/charlie.yaml
kubectl apply -f dave/dave.yaml
kubectl apply -f eve/eve.yaml
kubectl apply -f ferdie/ferdie.yaml
kubectl apply -f greg/greg.yaml
```
# Deploy stacks
```
kubectl apply -f alice/
kubectl apply -f bob/
kubectl apply -f charlie/
kubectl apply -f dave/
kubectl apply -f eve/
kubectl apply -f ferdie/
kubectl apply -f greg/
```
# Nuke pods
```
kubectl delete -f alice/alice.yaml
kubectl delete -f bob/bob.yaml
kubectl delete -f charlie/charlie.yaml
kubectl delete -f dave/dave.yaml
kubectl delete -f eve/eve.yaml
kubectl delete -f ferdie/ferdie.yaml
kubectl delete -f greg/greg.yaml
```
# Nuke stacks (including persistent data)
```
kubectl delete -f alice/
kubectl delete -f bob/
kubectl delete -f charlie/
kubectl delete -f dave/
kubectl delete -f eve/
kubectl delete -f ferdie/
kubectl delete -f greg/
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
# Get AWS Availability Zones for each node
```
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.labels.topology\.kubernetes\.io/zone}{"\n"}{end}'
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
kubectl get pod monitoring -o jsonpath='{.spec.nodeName}' -n sc
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

kubectl logs ferdie -c cardano-node -n sc
kubectl logs ferdie -c db-sync -n sc
kubectl logs ferdie -c postgres -n sc
kubectl logs ferdie -c bridge-backend -n sc
kubectl logs ferdie -c substrate-node -n sc
kubectl logs ferdie -c vector -n sc

kubectl logs greg -c cardano-node -n sc
kubectl logs greg -c db-sync -n sc
kubectl logs greg -c postgres -n sc
kubectl logs greg -c bridge-backend -n sc
kubectl logs greg -c substrate-node -n sc
kubectl logs greg -c vector -n sc

kubectl logs relay -c cardano-node -n sc
kubectl logs relay -c relay -n sc
kubectl logs relay -c ogmios -n sc
kubectl logs relay -c kupo -n sc
kubectl logs relay -c vector -n sc

kubectl logs monitoring grafana -n sc
kubectl logs monitoring prometheus -n sc
kubectl logs monitoring loki -n sc
kubectl logs monitoring vector -n sc

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

kubectl exec monitoring -it -c grafana -n monitoring -- sh
kubectl exec monitoring -it -c prometheus -n monitoring -- sh
kubectl exec monitoring -it -c loki -n monitoring -- sh
kubectl exec monitoring -it -c vector -n monitoring -- sh
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
# Update Grafana Dashboard

1. Edit dashboard in Grafana
2. Export dashboard as JSON
3. Copy JSON to clipboard
4. Edit src/kube/substrate-poc/environments/monitoring/grafana-dashboard.json
5. Paste JSON into grafana-dashboard.json
6. Commit and push changes to git
7. Delete the current grafana-dashboard ConfigMap
```
kubectl delete configmap grafana-dashboard -n monitoring
```
8. Create the new grafana-dashboard ConfigMap
```
kubectl create configmap grafana-dashboard --from-file=grafana-dashboard.json -n monitoring
```
# Promtail
```
kubectl get pods -n sc -l name=promtail
kubectl get pods -n sc -l name=promtail -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 kubectl logs -n monitoring
```

# Postgres

## Handy One Liner to create a temporary pod and connect to the postgres DB:

kubectl run postgres-test --rm -it -n sc --image=postgres -- bash -c "apt-get update && apt-get install -y postgresql-client && psql -h gh-actions-postgres-service.sc.svc.cluster.local -p 5432 -U postgres -d gh-actions-postgres"

## Credentials: postgres / sidechains