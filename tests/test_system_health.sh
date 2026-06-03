#!/usr/bin/env bash

set -euo pipefail

output=$(bash scripts/system-health.sh)

if [[ "$output" == "System Health OK" ]]; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi