kubectl get pods -n sidechains-substrate-poc-4 
kubectl describe pods -n sidechains-substrate-poc-4 

kubectl logs alice -c cardano-node -n sidechains-substrate-poc-4
kubectl logs alice -c db-sync -n sidechains-substrate-poc-4
kubectl logs alice -c postgres -n sidechains-substrate-poc-4
kubectl logs alice -c bridge-backend -n sidechains-substrate-poc-4
kubectl logs alice -c substrate-node -n sidechains-substrate-poc-4
kubectl logs alice -c vector -n sidechains-substrate-poc-4