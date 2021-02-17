#!/bin/bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/home/solana/taskset.out 2>&1

set -e 
set -o pipefail

MAINPID=${1}

/usr/bin/taskset -a -p -c 2-47 $MAINPID
/home/solana/bin/chrt -r 1 -p 70 $MAINPID
