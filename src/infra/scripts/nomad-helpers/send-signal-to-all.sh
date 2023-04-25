#!/usr/bin/env bash

echo Send a signal to all allocations in an environment...

select ENV in "unzen" "rausu"; do

  select SIG in "restart" "wipe" "restore"; do
    for TASK in validator passive faucet explorer; do
      for ID in $(nomad job allocs -namespace $ENV $TASK | awk 'NR > 1 { print $1 }'); do
        $(dirname "$0")/send-mamba-signal.sh "$SIG" "$ENV" "$ID"
      done
    done
    break
  done
  break
done
