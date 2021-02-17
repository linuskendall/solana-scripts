#!/usr/bin/env bash

XDG_RUNTIME_DIR="/run/user/$(id -u solana)"

VOTING_SERVICE_STATUS=$(systemctl --user is-active solana)
NO_VOTING_SERVICE_STATUS=$(systemctl --user is-active solana-no-voting)

set -o errexit
set -o nounset
set -o pipefail

if [ ! "${USER}" = "solana" ]; then
   echo "ERROR: This script should be run as the solana user."
   exit 1
fi

if [ "${VOTING_SERVICE_STATUS}" = "active" ]; then
    echo "ERROR: The solana voting service is active. Use restart-voting.sh instead or if needed stop-voting.sh."
    exit 1
fi

if [ "${NO_VOTING_SERVICE_STATUS}" = "active" ]; then
    echo "ERROR: The solana no voting service is active. Use restart-no-voting.sh instead or if needed stop-non-voting.sh."
    exit 1
fi


echo "WARNING: MAKE SURE THAT NO OTHER VOTING VALIDATOR IS RUNNING"
read -p "Are you sure you want to start the voting validator on ${HOSTNAME}? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	    exit 1
fi

start=$(date +%s.%N)

echo -n "Starting VOTING validator, time="
date 
systemctl --user start solana

echo -n "Waiting for the RPC service to come back up"

while ! nc -z localhost 8899; do   
	echo -n "."
	sleep 1 
done
echo "."

echo -n "RPC service started, time="
date

solana catchup --our-localhost

duration=$(echo "$(date +%s.%N) - $start" | bc)

echo -n "Finished restart, caught up, retval=" $? ", time="
date

execution_time=`printf "%.2f seconds" $duration`
echo "Start took: $execution_time"
