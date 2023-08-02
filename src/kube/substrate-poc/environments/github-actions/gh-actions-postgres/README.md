# Handy One Liner to create a temporary pod and connect to the postgres DB:

kubectl run postgres-test --rm -it -n sc --image=postgres -- bash -c "apt-get update && apt-get install -y postgresql-client && psql -h gh-actions-postgres-service.sc.svc.cluster.local -p 5432 -U postgres -d gh-actions-postgres"

# Credentials: postgres / sidechains