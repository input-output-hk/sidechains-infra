# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/
# Create namespace
kubectl create ns actions-runner-syste
# Create github token secret (needs repo:all and admin:repo_hook)
GITHUB_RUNNER_TOKEN=<token>
kubectl create secret generic controller-manager -n actions-runner-system --from-literal=github_token=$GITHUB_RUNNER_TOKEN
# Install helm chart 
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo update
helm upgrade --install --namespace actions-runner-system --create-namespace --wait actions-runner-controller actions-runner-controller/actions-runner-controller --set syncPeriod=1m
# Create runner
kubectl create -f runner.yaml


# Verifications
kubectl --namespace actions-runner-system get all
kubectl get pod -n actions-runner-system | grep -i "k8s-action-runner"