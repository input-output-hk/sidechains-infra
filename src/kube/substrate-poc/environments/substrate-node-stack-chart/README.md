# Setup Local Shell
```
nix-shell -p kubectl awscli2 kubernetes-helm
export AWS_SECRET_ACCESS_KEY=<key>
export AWS_ACCESS_KEY_ID=<key>
aws eks update-kubeconfig --region eu-central-1 --name iog-sidechain-substrate-kubernetes
```

# Helm

## Render Pod
```
helm template . -f values/alice.yaml
helm template . -f values/bob.yaml
helm template . -f values/charlie.yaml
helm template . -f values/dave.yaml
helm template . -f values/eve.yaml
helm template . -f values/ferdie.yaml
```
## Deploy Pod
```
helm install alice . -f values/alice.yaml
helm install bob . -f values/bob.yaml
helm install charlie . -f values/charlie.yaml
helm install dave . -f values/dave.yaml
helm install eve . -f values/eve.yaml
helm install ferdie . -f values/ferdie.yaml
helm install greg . -f values/greg.yaml
```                           
## Destroy Pod
```
helm uninstall alice
helm uninstall bob
helm uninstall charlie
helm uninstall dave
helm uninstall eve
helm uninstall ferdie
helm uninstall greg  
```

# Kubectl

## Get Queries
```
kubectl get pods -n sc          # high level summary
kubectl get sc -n sc            # storage classes
kubectl get pvc -n sc           # persistent volume claims
kubectl get pv -n sc            # persistent volumes
kubectl get svc -n sc           # services
kubectl get node -n sc          # nodes
kubectl get pods -o wide -n sc  # full summary
```

## Describe Queries
```
kubectl describe pods -n sc          # detailed summary
kubectl describe sc -n sc            # storage classes
kubectl describe pvc -n sc           # persistent volume claims
kubectl describe pv -n sc            # persistent volumes
kubectl describe svc -n sc           # services
kubectl describe node -n sc          # nodes
```

## Logs
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
```
## Exec 
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

kubectl exec ferdie -it -c cardano-node -n sc -- sh
kubectl exec ferdie -it -c db-sync -n sc -- sh
kubectl exec ferdie -it -c postgres -n sc -- sh
kubectl exec ferdie -it -c bridge-backend -n sc -- sh
kubectl exec ferdie -it -c substrate-node -n sc -- sh
kubectl exec ferdie -it -c vector -n sc -- sh

kubectl exec greg -it -c cardano-node -n sc -- sh
kubectl exec greg -it -c db-sync -n sc -- sh
kubectl exec greg -it -c postgres -n sc -- sh
kubectl exec greg -it -c bridge-backend -n sc -- sh
kubectl exec greg -it -c substrate-node -n sc -- sh
kubectl exec greg -it -c vector -n sc -- sh
```