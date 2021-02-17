#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "WARNING: THIS WILL LEAD TO VOTING VALIDATOR DOWNTIME"
read -p "Are you sure you want to restart the voting validator on ${HOSTNAME}? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	    exit 1
fi

echo "Waiting for snapshot"
grep -m1 'snapshot-' < <(inotifywait -m -e moved_to /solana/ledger) 

start=$(date +%s.%N)

echo -n "Starting restart, time="
date 
systemctl --user restart solana

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
