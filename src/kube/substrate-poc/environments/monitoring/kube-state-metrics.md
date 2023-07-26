# Install
helm install kube-state-metrics prometheus-community/kube-state-metrics -n monitoring

# Verify
kubectl get pods -n monitoring -l app.kubernetes.io/name=kube-state-metrics
kubectl logs -l app.kubernetes.io/name=kube-state-metrics -n monitoring
kubectl run -it --rm --restart=Never dig --image tutum/dnsutils -- dig kube-state-metrics.monitoring.svc.cluster.local