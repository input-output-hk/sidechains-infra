#!/bin/bash

# Define the labels for the 6 nodes
labels=("alice" "bob" "charlie" "dave" "eve" "monitoring")

# Get the list of nodes
nodes=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')

# Convert string to array
nodes_array=($nodes)

# Iterate over the nodes and label them
for i in ${!nodes_array[@]}; do
  kubectl label nodes ${nodes_array[$i]} pod=${labels[$i]}
done
