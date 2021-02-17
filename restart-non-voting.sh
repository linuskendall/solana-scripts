#!/usr/bin/env bash

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
    echo "ERROR: This machine is currently running a voting service. This is probably not the command you want to use"
    exit 1  
fi

if [ ! "${NO_VOTING_SERVICE_STATUS}" = "active" ]; then
    echo "ERROR: The solana no voting service is not active. Use start-non-voting.sh instead."
    exit 1
else
    echo "Solana no voting service is active. Proceeding."
fi

echo "Checking that we're caught up"
solana catchup --our-localhost

echo "Waiting for snapshot"
grep -m1 'snapshot-' < <(inotifywait -m -e moved_to /solana/ledger) 

start=$(date +%s.%N)

echo -n "Starting restart, time="
date 
systemctl --user restart solana-no-voting

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
echo "Restart took: $execution_time"
