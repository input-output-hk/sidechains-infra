#!/usr/bin/env bash

function print_help() {
  echo "Usage: $0 <namespace> <alloc name> <restart|wipe|backup|restore>"
  echo "Wait for allocation with <alloc name> to be running and send signal"
}

if [ "$1" == "-h" ]; then
  print_help
  exit 1
fi

NAMESPACE="$1"
ALLOC_NAME="$2"
SIGNAL="$3"

FORMAT="{{range .}} {{.Name}} {{.ID}} {{.ClientStatus}}
{{end}}"

function find_running_alloc() {
  nomad alloc status -namespace $NAMESPACE -t "$FORMAT" |
    grep "running" |
    grep -F "$ALLOC_NAME" |
    awk '{ print $2 }' | head -n 1
}

echo "Waitnig for $ALLOC_NAME to be running."

while true; do
  ALLOC=$(find_running_alloc)
  if [ ! -z "$ALLOC" ]; then
    echo Alloc found, sending $signal signal
    $(dirname "$0")/send-mamba-signal.sh "$SIGNAL" "$NAMESPACE" "$ALLOC"
    exit
  else
    echo Alloc not found, sleeping for 10 s...
    sleep 10
  fi
done
