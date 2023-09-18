# Helm Installation

helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd

# YAML Installation

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# The initial password is the argocd-server pod name.

# Client

brew install argocd


