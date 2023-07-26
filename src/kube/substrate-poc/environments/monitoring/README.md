# Updating Grafana Dashboard

kubectl delete configmap grafana-dashboard -n monitoring

kubectl create configmap grafana-dashboard --from-file=grafana-dashboard.json -n monitoring -o yaml --dry-run=client | kubectl label --local -f - -o yaml grafana_dashboard="1" | kubectl apply -f -
