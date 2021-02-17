#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "WARNING: ONLY DO THIS ON NON VOTING NODE TO START IT IN VOTING MODE"
read -p "Have you stopped any other voting validators? This will start voting validator on ${HOSTNAME}. " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	    exit 1
fi

echo "Waiting for snapshot"
grep -m1 'snapshot-' < <(inotifywait -m -e moved_to /solana/ledger) 

start=$(date +%s.%N)

echo -n "Starting restart to voting mode, time="
date 
echo "Stopping non-voting validator"
systemctl --user stop solana-no-voting

echo "Starting voting validator"
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
echo "Restart took: $execution_time"
