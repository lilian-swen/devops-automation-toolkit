#!/bin/bash
#
# Name: create-user-automated.sh
# Description: Creates a new user on the local system non-interactively with a generated password.
# Usage: ./create-user-automated.sh <username> <full_name>
# Example call: ./create-user-automated.sh dak "Dakota"


# Ensure the script is run as root
if [[ "${UID}" -ne 0 ]]; then
    echo 'Error: Please run with sudo or as root.' >&2
    exit 1
fi

# Check for correct number of arguments
if [[ "${#}" -ne 2 ]]; then
    echo "Usage: ${0} <username> <full_name>" >&2
    exit 1
fi

USER_NAME="${1}"
COMMENT="${2}"

# Check if user already exists to maintain idempotency
if id "${USER_NAME}" &>/dev/null; then
    echo "User ${USER_NAME} already exists. Skipping creation."
    exit 0
fi

# Generate a random password (12 characters, alphanumeric + special characters)
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c 12)

# Create the account
useradd -c "${COMMENT}" -m "${USER_NAME}"
if [[ "${?}" -ne 0 ]]; then
    echo "Error: Could not create account for ${USER_NAME}." >&2
    exit 1
fi

# Set the generated password
echo "${PASSWORD}" | passwd --stdin "${USER_NAME}" &>/dev/null
if [[ "${?}" -ne 0 ]]; then
    echo "Error: Could not set password for ${USER_NAME}." >&2
    exit 1
fi

# Force password change on first login
passwd -e "${USER_NAME}" &>/dev/null

echo "User ${USER_NAME} successfully created."
echo "Temporary password: ${PASSWORD}"
echo "User will be forced to change this password on first login."
exit 0