#!/bin/bash
set -euo pipefail

###############################################################################
# Backup Freshness Monitor (Production Hardened)
#
# Purpose:
#   Monitors the freshness of backup files in a given directory and triggers
#   alerts when backups exceed defined WARNING or CRITICAL age thresholds.
#
# Design:
#   - WARNING state for early detection (degraded backup freshness)
#   - CRITICAL state for SLA violation / backup failure conditions
#   - Syslog + optional file logging for observability
#
# Exit Codes:
#   0 = OK (backup is within acceptable threshold)
#   1 = WARNING (backup is aging but still within tolerance)
#   2 = CRITICAL (missing backups, invalid state, or SLA breach)
#
# Usage:
#   ./backup_freshness_monitor.sh [backup_directory] [warning_hours] [critical_hours]
###############################################################################

#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------

# BACKUP_DIR="${1:-/var/backups/db}"
BACKUP_DIR="${1:-/tmp/backup-test-suite}"
WARNING_HOURS="${2:-20}"
CRITICAL_HOURS="${3:-28}"

ADMIN_EMAIL="lilian.swen@outlook.com"
HOSTNAME="$(hostname)"

LOG_TAG="backup-freshness-monitor"
LOG_FILE="/tmp/backup_freshness_monitor.log"

#------------------------------------------------------------------------------
# Logging Utility
#------------------------------------------------------------------------------
# Sends logs to:
#   - syslog (via logger)
#   - optional local file for audit/debug purposes
log() {
    local level="$1"
    local msg="$2"

    logger -t "$LOG_TAG" "[$level] $msg"

    if [[ -n "${LOG_FILE:-}" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $msg" >> "$LOG_FILE"
    fi
}

#------------------------------------------------------------------------------
# Input Validation
#------------------------------------------------------------------------------
# Ensure target directory exists before proceeding with file operations.
if [[ ! -d "$BACKUP_DIR" ]]; then
    log "CRITICAL" "Backup directory not found: $BACKUP_DIR"
    echo "CRITICAL: Backup directory missing"
    exit 2
fi

#------------------------------------------------------------------------------
# Locate Most Recent Backup (Portable approach)
#------------------------------------------------------------------------------
# Uses find instead of ls parsing to avoid fragile output handling.
# This is safer across different environments and locales.
LATEST_FILE="$(find "$BACKUP_DIR" -type f 2>/dev/null | sort | tail -n 1 || true)"

if [[ -z "$LATEST_FILE" ]]; then
    log "CRITICAL" "No backup files found in $BACKUP_DIR"
    echo "CRITICAL: No backups found"
    exit 2
fi

#------------------------------------------------------------------------------
# File Integrity Validation
#------------------------------------------------------------------------------
# Ensure the selected backup is a valid, non-empty file.
if [[ ! -f "$LATEST_FILE" ]]; then
    log "CRITICAL" "Latest backup is not a valid file: $LATEST_FILE"
    exit 2
fi

FILE_SIZE="$(stat -c %s "$LATEST_FILE" 2>/dev/null || stat -f %z "$LATEST_FILE" 2>/dev/null || echo 0)"

if [[ "$FILE_SIZE" -le 0 ]]; then
    log "CRITICAL" "Backup file is empty or unreadable: $LATEST_FILE"
    exit 2
fi

#------------------------------------------------------------------------------
# Backup Age Calculation
#------------------------------------------------------------------------------
# Extract file modification time in epoch seconds (cross-platform fallback).
MOD_TIME="$(stat -c %Y "$LATEST_FILE" 2>/dev/null || stat -f %m "$LATEST_FILE" 2>/dev/null)"

NOW="$(date +%s)"

AGE_SECONDS=$((NOW - MOD_TIME))
AGE_HOURS=$((AGE_SECONDS / 3600))

log "INFO" "Latest backup: $LATEST_FILE | size=${FILE_SIZE} bytes | age=${AGE_HOURS}h"

#------------------------------------------------------------------------------
# Monitoring Logic (WARNING + CRITICAL tiers)
#------------------------------------------------------------------------------
# CRITICAL: backup SLA breach
if [[ "$AGE_HOURS" -ge "$CRITICAL_HOURS" ]]; then

    MESSAGE="CRITICAL: Backup is ${AGE_HOURS}h old on ${HOSTNAME} (${LATEST_FILE})"
    SUBJECT="[CRITICAL] Backup Failure on ${HOSTNAME}"

    log "CRITICAL" "$MESSAGE"
    echo "$MESSAGE" | mail -s "$SUBJECT" "$ADMIN_EMAIL"

    exit 2

# WARNING: early degradation signal
elif [[ "$AGE_HOURS" -ge "$WARNING_HOURS" ]]; then

    MESSAGE="WARNING: Backup is ${AGE_HOURS}h old on ${HOSTNAME} (${LATEST_FILE})"
    SUBJECT="[WARNING] Backup Delay on ${HOSTNAME}"

    log "WARNING" "$MESSAGE"
    echo "$MESSAGE" | mail -s "$SUBJECT" "$ADMIN_EMAIL"

    exit 1

# OK: system healthy
else

    MESSAGE="OK: Backup is healthy (${AGE_HOURS}h old)"
    log "INFO" "$MESSAGE"

    echo "$MESSAGE"
    exit 0
fi