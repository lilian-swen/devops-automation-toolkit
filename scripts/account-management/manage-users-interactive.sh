#!/bin/bash

# Ensure running as root
if [[ "${UID}" -ne 0 ]]; then
    echo "Error: This script must be run as root (sudo)." >&2
    exit 1
fi

echo "--- Current Human Users (UID >= 1000) ---"
# Display users clearly using column formatting
awk -F: '$3 >= 1000 && $3 != 65534 {print "- " $1}' /etc/passwd
echo "------------------------------------------"

# Prompt for the user to delete
read -p "Enter the username you wish to delete: " TARGET_USER

# Idempotency check: Does the user exist?
if ! id "${TARGET_USER}" &>/dev/null; then
    echo "Error: User '${TARGET_USER}' does not exist." >&2
    exit 1
fi

# Confirm deletion
read -p "Are you sure you want to delete '${TARGET_USER}' and their home directory? (y/n) " CONFIRM
if [[ "${CONFIRM}" != "y" ]]; then
    echo "Deletion cancelled."
    exit 0
fi

# Perform deletion
if sudo userdel -r "${TARGET_USER}"; then
    echo "Successfully deleted user '${TARGET_USER}'."
    
    # Final validation check
    if ! id "${TARGET_USER}" &>/dev/null; then
        echo "Verification: User '${TARGET_USER}' is now invalid/removed."
    else
        echo "Warning: User '${TARGET_USER}' appears to still exist." >&2
    fi
else
    echo "Error: Failed to delete user '${TARGET_USER}'." >&2
    exit 1
fi