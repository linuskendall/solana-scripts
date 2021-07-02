#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/home/solana/rsync.log 2>&1

echo -n "Starting sync on "
date

rsync -avh -e ssh --progress /solana/ledger/tower-DDnAqxJVFo2GVTujibHt5cjevHMSE9bo8HJaydHoshdp.bin solana-lax:/solana/


echo
