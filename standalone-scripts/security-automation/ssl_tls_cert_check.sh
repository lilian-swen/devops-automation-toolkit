#!/bin/bash

###############################################################################
# ssl-tls-cert-check.sh
#
# Purpose:
#   Validate the SSL/TLS certificate expiration date for a given domain and
#   return monitoring-friendly exit codes.
#
# Usage:
#   ./ssl-tls-cert-check.sh <domain> <warning_days>
#
# Example:
#   ./ssl-tls-cert-check.sh example.com 30
#
# Exit Codes:
#   0 - Certificate is valid and above warning threshold
#   1 - Script execution error or invalid input
#   2 - Certificate expiration is within warning threshold
#
# Dependencies:
#   - openssl
#   - GNU date
#
# Typical Use Cases:
#   - Cron jobs
#   - Monitoring systems (Nagios, Icinga, Zabbix)
#   - CI/CD health checks
#   - Infrastructure compliance checks
###############################################################################

# Target domain to check
DOMAIN=$1

# Alert threshold (days before expiration)
WARNING_DAYS=$2

# Validate required arguments
if [ -z "$DOMAIN" ] || [ -z "$WARNING_DAYS" ]; then
    echo "Usage: $0 <domain> <warning_days>"
    exit 1
fi

###############################################################################
# Retrieve certificate expiration date from the remote endpoint.
#
# openssl s_client:
#   Establishes a TLS connection to the target host.
#
# openssl x509 -noout -enddate:
#   Extracts only the certificate expiration timestamp.
###############################################################################
EXP_DATE=$(
    echo | openssl s_client \
        -servername "$DOMAIN" \
        -connect "$DOMAIN":443 \
        2>/dev/null |
    openssl x509 -noout -enddate |
    cut -d= -f2
)

# Fail if certificate information cannot be retrieved
if [ -z "$EXP_DATE" ]; then
    echo "ERROR: Unable to retrieve certificate information for $DOMAIN"
    exit 1
fi

###############################################################################
# Convert timestamps to Unix epoch format to simplify date arithmetic.
###############################################################################
EXP_SEC=$(date -d "$EXP_DATE" +%s)
NOW_SEC=$(date +%s)

# Calculate full days remaining before certificate expiration
REMAINING_DAYS=$(( (EXP_SEC - NOW_SEC) / 86400 ))

echo "Certificate for $DOMAIN expires in $REMAINING_DAYS days."

###############################################################################
# Monitoring Logic
#
# Exit Code 2 is commonly interpreted as CRITICAL by monitoring platforms.
# Exit Code 0 indicates healthy status.
###############################################################################
if [ "$REMAINING_DAYS" -lt "$WARNING_DAYS" ]; then
    echo "CRITICAL: Certificate expires in less than $WARNING_DAYS days."
    exit 2
fi

echo "OK: Certificate validity is above warning threshold."
exit 0