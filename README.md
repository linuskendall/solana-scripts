# To start

Unlike the restart command below these will be a no-op if the validator is already running. They  do not wait for the creation of a snapshot before starting up (unlike restart below).

To start a non voting validator use: /home/solana/bin/start-non-voting.sh

To start a voting validator use: /home/solana/bin/start-voting.sh

These commands will wait for an report on catch up.

# To stop

To stop non voting validator use: /home/solana/bin/stop-non-voting.sh

To stop voting validator use: /home/solana/bin/stop-voting.sh

Both will require confirmation before the stop.

# To restart

The restart scripts will wait until a snapshot has been created before actually executing the restart.

To restart non voting validator use: /home/solana/bin/restart-non-voting.sh

To restart voting validator use: /home/solana/bin/restart-voting.sh 

You will need to confirm restart of voting validator by pressing "y" on the prompt.

These commands will wait for an report on catch up.

# To failover 

All commands to be run as the solana user. The old node is the old validator node, the new node is the new validator node. These commands use transferring from nyc to lax as an example, if you are moving in the opposite direction change the solana-lax to solana-nyc in the commands.

1. (on old node) If possible, stop solana on the old machine: /home/solana/bin/stop-voting.sh

2. (on old node) Stop the tower syncing (comment out in crontab): crontab -e

3. (on new node) Stop the non voting node: /home/solana/bin/stop-non-voting.sh

4a. (on old node) Sync the tower file: /home/solana/bin/sync-to-lax.sh
4b. (on old node) If required, rsync all files: rsync -avh -e ssh --progress --exclude 'rocksdb' /solana/ledger/ solana-lax:/solana/ledger/

5. (on new node) Start the new validator: /home/solana/bin/start-voting-validator.sh

Later you can track progress (on new node): systemctl --user status solana

To follow logs: journalctl --user -u solana -f 

You can use the hostnames solana-lax and solana-nyc to refer to the two different hosts

