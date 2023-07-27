# Configmaps

kubectl create configmap relay-configmap --from-file=./config/preview -n sc

# Each file in the directory will become a data item in the ConfigMap, where the key is the filename and the value is the file content. Please ensure you are in the correct directory when running the command, as the --from-file option uses relative paths.
