kubectl get pods -n sidechains-substrate-poc-4 
kubectl describe pods -n sidechains-substrate-poc-4 

# Apply

kubectl apply -f alice.yaml
kubectl apply -f bob.yaml
kubectl apply -f charlie.yaml
kubectl apply -f dave.yaml
kubectl apply -f eve.yaml

# Delete

kubectl delete -f alice.yaml
kubectl delete -f bob.yaml
kubectl delete -f charlie.yaml
kubectl delete -f dave.yaml
kubectl delete -f eve.yaml

# Describe

kubectl get pods -n sidechains-substrate-poc-4
kubectl describe pods -n sidechains-substrate-poc-4

# Logs

kubectl logs alice -c cardano-node -n sidechains-substrate-poc-4
kubectl logs alice -c db-sync -n sidechains-substrate-poc-4
kubectl logs alice -c postgres -n sidechains-substrate-poc-4
kubectl logs alice -c bridge-backend -n sidechains-substrate-poc-4
kubectl logs alice -c substrate-node -n sidechains-substrate-poc-4
kubectl logs alice -c vector -n sidechains-substrate-poc-4

kubectl logs bob -c cardano-node -n sidechains-substrate-poc-4
kubectl logs bob -c db-sync -n sidechains-substrate-poc-4
kubectl logs bob -c postgres -n sidechains-substrate-poc-4
kubectl logs bob -c bridge-backend -n sidechains-substrate-poc-4
kubectl logs bob -c substrate-node -n sidechains-substrate-poc-4
kubectl logs bob -c vector -n sidechains-substrate-poc-4

kubectl logs charlie -c cardano-node -n sidechains-substrate-poc-4
kubectl logs charlie -c db-sync -n sidechains-substrate-poc-4
kubectl logs charlie -c postgres -n sidechains-substrate-poc-4
kubectl logs charlie -c bridge-backend -n sidechains-substrate-poc-4
kubectl logs charlie -c substrate-node -n sidechains-substrate-poc-4
kubectl logs charlie -c vector -n sidechains-substrate-poc-4

kubectl logs dave -c cardano-node -n sidechains-substrate-poc-4
kubectl logs dave -c db-sync -n sidechains-substrate-poc-4
kubectl logs dave -c postgres -n sidechains-substrate-poc-4
kubectl logs dave -c bridge-backend -n sidechains-substrate-poc-4
kubectl logs dave -c substrate-node -n sidechains-substrate-poc-4
kubectl logs dave -c vector -n sidechains-substrate-poc-4

kubectl logs eve -c cardano-node -n sidechains-substrate-poc-4
kubectl logs eve -c db-sync -n sidechains-substrate-poc-4
kubectl logs eve -c postgres -n sidechains-substrate-poc-4
kubectl logs eve -c bridge-backend -n sidechains-substrate-poc-4
kubectl logs eve -c substrate-node -n sidechains-substrate-poc-4
kubectl logs eve -c vector -n sidechains-substrate-poc-4