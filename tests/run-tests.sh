#!/usr/bin/env bash

set -euo pipefail

echo "Running tests..."

for test_file in tests/test-*.sh; do
    echo "Executing $test_file"
    bash "$test_file"
done

echo "All tests passed!"