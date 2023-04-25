#!/usr/bin/env bash

function print_help() {
  echo "Usage: $0 <restart|wipe|backup|restore> <namespace> <alloc id>"
  echo Send a signal to an allocation
}

if [ "$1" == "-h" ]; then
  print_help
  exit 1
fi

signal_name=${1:?$(print_help)}
namespace=${2:?$(print_help)}
alloc=${3:?$(print_help)}

case "$signal_name" in
"restart")
  SIG="SIGHUP"
  ;;
"wipe")
  SIG="SIGUSR1"
  ;;
"backup")
  SIG="SIGUSR2"
  ;;
"restore")
  SIG="SIGWINCH"
  ;;
*)
  print_help
  exit
  ;;
esac

if [ -z "$namespace" ] || [ -z "$alloc" ]; then
  print_help
  exit
fi

nomad alloc signal -namespace="$namespace" -s "$SIG" "$alloc" mamba
