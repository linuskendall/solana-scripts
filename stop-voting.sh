#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "WARNING: THIS WILL LEAD TO VOTING VALIDATOR DOWNTIME"
read -p "Are you sure you want to stop the voting validator on ${HOSTNAME}? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	    exit 1
fi

systemctl --user stop solana
