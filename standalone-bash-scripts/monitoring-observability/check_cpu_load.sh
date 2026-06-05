#!/bin/bash

# ==============================================================================
# Script Name: check-cpu-load.sh
# Description: Checks CPU load average and alerts if it exceeds thresholds.
#              Designed for integration with monitoring systems (Nagios/Zabbix).
# ==============================================================================

# Thresholds (Configurable)
# WARN: Triggers warning state
# CRIT: Triggers critical state
WARN_THRESHOLD=2.0
CRIT_THRESHOLD=4.0

# 1. Get CPU load for the last 5 minutes (index 10 in output of uptime)
# Note: 'uptime' output format varies slightly; this parses the comma-separated values
LOAD_5MIN=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f2 | xargs)

# 2. Validation: Ensure we captured a valid number
if [[ -z "$LOAD_5MIN" ]]; then
    echo "UNKNOWN: Could not parse CPU load."
    exit 3
fi

# 3. Evaluation Logic
# Using 'bc' for floating-point comparison
if (( $(echo "$LOAD_5MIN > $CRIT_THRESHOLD" | bc -l) )); then
    echo "CRITICAL: CPU Load is high at $LOAD_5MIN (Threshold: $CRIT_THRESHOLD)"
    exit 2
elif (( $(echo "$LOAD_5MIN > $WARN_THRESHOLD" | bc -l) )); then
    echo "WARNING: CPU Load is elevated at $LOAD_5MIN (Threshold: $WARN_THRESHOLD)"
    exit 1
else
    echo "OK: CPU Load is healthy at $LOAD_5MIN"
    exit 0
fi