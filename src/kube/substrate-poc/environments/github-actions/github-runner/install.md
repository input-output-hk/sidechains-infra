# https://github.com/actions/actions-runner-controller/blob/master/docs/quickstart.md

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml
kubectl create -f actions-runner-controller.yaml
kubectl apply -f sidechains-test-runner.yaml
kubectl create secret generic controller-manager \
    -n actions-runner-system \
    --from-literal=github_token=<Personal Access Token with Repo permissions>