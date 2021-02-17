#!/usr/bin/env bash

XDG_RUNTIME_DIR="/run/user/$(id -u solana)"

set -o errexit
set -o nounset
set -o pipefail

if [ ! "${USER}" = "solana" ]; then
   echo "ERROR: This script should be run as the solana user."
   exit 1
fi

echo "WARNING: THIS WILL LEAD TO NON-VOTING VALIDATOR GETTING OUT OF SYNC"
read -p "Are you sure you want to stop the non-voting validator on ${HOSTNAME}? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	    exit 1
fi

systemctl --user stop solana-no-voting
