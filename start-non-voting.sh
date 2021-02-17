#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

start=$(date +%s.%N)

echo -n "Starting NON-VOTING validator, time="
date 
systemctl --user start solana-no-voting

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
