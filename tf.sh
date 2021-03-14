#!/bin/bash

XDG_RUNTIME_DIR="/run/user/$(id -u solana)"

NO_VOTING_SERVICE_STATUS=$(systemctl --user is-active solana-no-voting)
VOTING_SERVICE_STATUS=$(systemctl --user is-active solana)

set -o errexit
set -o nounset
set -o pipefail

if [ ! "${USER}" = "solana" ]; then
   echo "ERROR: This script should be run as the solana user."
   exit 1
fi

if [ "${VOTING_SERVICE_STATUS}" = "active" ]; then
    journalctl --user -u solana -f "$@"
elif [ "${NO_VOTING_SERVICE_STATUS}" = "active" ]; then
    journalctl --user -u solana-no-voting -f "$@"
else
    echo "WARNING: The solana service is currently not running. Specify which you want by adding -u solana or -u solana-no-voting on the command line."
    journalctl --user -f "$@"
fi
