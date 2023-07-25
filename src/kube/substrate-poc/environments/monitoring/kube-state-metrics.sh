helm install kube-state-metrics prometheus-community/kube-state-metrics -n monitoring
kubectl get pods -n monitoring -l app.kubernetes.io/name=kube-state-metrics
kubectl logs -l app.kubernetes.io/name=kube-state-metrics -n monitoring