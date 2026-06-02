#!/bin/bash
#
# Name: create-user-automated.sh
# Description: Creates a new user on the local system non-interactively.
# Usage: ./create-user-automated.sh <username> <full_name> <password>
# Example call: ./create-user-automated.sh jdoe "John Doe" "P@ssw0rd"


# Ensure the script is run as root
if [[ "${UID}" -ne 0 ]]; then
    echo 'Error: Please run with sudo or as root.' >&2
    exit 1
fi

# Check for correct number of arguments
if [[ "${#}" -ne 3 ]]; then
    echo "Usage: ${0} <username> <full_name> <password>" >&2
    exit 1
fi

USER_NAME="${1}"
COMMENT="${2}"
PASSWORD="${3}"

# Check if user already exists to maintain idempotency
if id "${USER_NAME}" &>/dev/null; then
    echo "User ${USER_NAME} already exists. Skipping creation."
    exit 0
fi

# Create the account
useradd -c "${COMMENT}" -m "${USER_NAME}"
if [[ "${?}" -ne 0 ]]; then
    echo "Error: Could not create account for ${USER_NAME}." >&2
    exit 1
fi

# Set the password
echo "${PASSWORD}" | passwd --stdin "${USER_NAME}" &>/dev/null
if [[ "${?}" -ne 0 ]]; then
    echo "Error: Could not set password for ${USER_NAME}." >&2
    exit 1
fi

# Force password change on first login
passwd -e "${USER_NAME}" &>/dev/null

echo "User ${USER_NAME} successfully created on ${HOSTNAME}."
exit 0