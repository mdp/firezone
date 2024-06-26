#!/usr/bin/env bash

set -euox pipefail

source "./scripts/tests/lib.sh"

docker compose exec --env RUST_LOG=info -it client /bin/sh -c 'iperf3 \
  --udp \
  --bandwidth 50M \
  --client 172.20.0.110 \
  --json' >>"${TEST_NAME}.json"

assert_process_state "gateway" "S"
assert_process_state "client" "S"
