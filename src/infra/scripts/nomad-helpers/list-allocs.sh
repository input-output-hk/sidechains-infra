#!/usr/bin/env bash

function print_help() {
  echo "Usage: $0  <namespace>"
}

NAMESPACE=${1:?missing namespace. $(print_help)}

HEADER="allocName allocId status"
FORMAT="{{range .}} {{.Name}} {{.ID}} {{.ClientStatus}}
{{end}}"

(
  echo "$HEADER"
  nomad alloc status -namespace $NAMESPACE -t "$FORMAT" | sort -u
) | column -t
