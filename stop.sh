#!/usr/bin/env bash

XDG_RUNTIME_DIR="/run/user/$(id -u solana)"

set -o errexit
set -o nounset
set -o pipefail

if [ ! "${USER}" = "solana" ]; then
   echo "ERROR: This script should be run as the solana user."
   exit 1
fi

if [ "${VOTING_SERVICE_STATUS}" = "active" ]; then
    VALIDATOR_TYPE="VOTING"
    UNIT_NAME=solana
elif [ "${NO_VOTING_SERVICE_STATUS}" = "active" ]; then
    VALIDATOR_TYPE="NON-VOTING"
    UNIT_NAME=solana-no-voting
else
    echo "ERROR: The solana service is currently not running. Use start.sh instead."
    echo "Voting status: " ${VOTING_SERVICE_STATUS}
    echo "No voting status: " ${NO_VOTING_SERVICE_STATUS}
    exit 1
fi

echo "WARNING: THIS WILL LEAD TO ${VALIDATOR_TYPE} VALIDATOR DOWNTIME"
read -p "Are you sure you want to stop the ${VALIDATOR_TYPE} validator on ${HOSTNAME}? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	    exit 1
fi

read -p "Would you like to wait for a snapshot before stopping? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  grep -m1 'snapshot-' < <(inotifywait -m -e moved_to /solana/ledger) 
fi

systemctl --user stop ${UNIT_NAME}
