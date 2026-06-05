#!/bin/bash

###############################################################################
# Test Suite for Backup Freshness Monitor
#
# Purpose:
#   Automatically validates monitoring script behavior across multiple cases:
#     - OK (fresh backup)
#     - WARNING threshold
#     - CRITICAL threshold
#     - Empty directory
#     - Missing directory
#
# Usage:
#   ./backup_freshness_monitor_test.sh
###############################################################################

SCRIPT="./backup_freshness_monitor.sh"
TEST_DIR="/tmp/backup-test-suite"

# Clean start
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

echo "======================================"
echo "  Backup Monitor Test Suite"
echo "======================================"

#------------------------------------------------------------------------------
# Helper function
#------------------------------------------------------------------------------
run_test() {
    local name="$1"
    shift

    echo ""
    echo ">>> TEST: $name"
    echo "--------------------------------------"

    set +e
    "$SCRIPT" "$@"
    local exit_code=$?
    set -e

    echo "Exit code: $exit_code"
    echo "--------------------------------------"
}

#------------------------------------------------------------------------------
# 1. OK scenario (fresh backup)
#------------------------------------------------------------------------------
touch "$TEST_DIR/backup_ok.tar"

run_test "OK Scenario (fresh backup)" \
    "$TEST_DIR" 20 28

#------------------------------------------------------------------------------
# 2. WARNING scenario (older than warning threshold)
#------------------------------------------------------------------------------
touch -d "25 hours ago" "$TEST_DIR/backup_warning.tar"

run_test "WARNING Scenario (25h old backup)" \
    "$TEST_DIR" 20 28

#------------------------------------------------------------------------------
# 3. CRITICAL scenario (older than critical threshold)
#------------------------------------------------------------------------------
touch -d "35 hours ago" "$TEST_DIR/backup_critical.tar"

run_test "CRITICAL Scenario (35h old backup)" \
    "$TEST_DIR" 20 28

#------------------------------------------------------------------------------
# 4. Empty directory scenario
#------------------------------------------------------------------------------
mkdir -p /tmp/empty-backup

run_test "EMPTY Directory Scenario" \
    "/tmp/empty-backup" 20 28

#------------------------------------------------------------------------------
# 5. Missing directory scenario
#------------------------------------------------------------------------------
run_test "MISSING Directory Scenario" \
    "/tmp/does-not-exist-xyz" 20 28

#------------------------------------------------------------------------------
# Cleanup
#------------------------------------------------------------------------------
rm -rf "$TEST_DIR"

echo ""
echo "======================================"
echo "  Test Suite Completed"
echo "======================================"