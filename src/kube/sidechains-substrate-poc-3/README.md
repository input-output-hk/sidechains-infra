# Introduction

Kustomize is a Kubernetes configuration management tool that simplifies customization and deployment management. It looks for a kustomize.yaml file to define configurations and customization options, which can be substitued into the base configuration. This allows for a single base configuration to be used for multiple deployments, with only the customization options changing.

# Deploy

kubectl apply -k overlays/alice/
kubectl apply -k overlays/bob/
kubectl apply -k overlays/charlie/
kubectl apply -k overlays/dave/
kubectl apply -k overlays/eve/

# Destroy

kubectl delete -k overlays/alice/
kubectl delete -k overlays/bob/
kubectl delete -k overlays/charlie/
kubectl delete -k overlays/dave/
kubectl delete -k overlays/eve/

# Render

kubectl kustomize overlays/alice/
kubectl kustomize overlays/bob/
kubectl kustomize overlays/charlie/
kubectl kustomize overlays/dave/
kubectl kustomize overlays/eve/