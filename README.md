# To start nodes

Unlike the restart command below these will be a no-op if the validator is already running. They  do not wait for the creation of a snapshot or cathing up before starting up (unlike restart below).

To start a non voting validator use: `/home/solana/bin/start-non-voting.sh`

To start a voting validator use: `/home/solana/bin/start-voting.sh`

These commands will wait for an report on catch up.

# To stop nodes 

To follow logs: `journalctl --user -u solana -f`

To stop validator use: `/home/solana/bin/stop.sh`

Both will require confirmation before the stop.

# To restart

The restart scripts will wait until a snapshot has been created before actually executing the restart.

To restart validator use: `/home/solana/bin/restart.sh`

You will need to confirm restart of voting validator by pressing "y" on the prompt.

These commands will wait for an report on catch up.

# To failover 

All commands to be run as the solana user. The old node is the old validator node, the new node is the new validator node. These commands use transferring from nyc to lax as an example, if you are moving in the opposite direction change the solana-lax to solana-nyc in the commands.

If the previous machine is running, then on the old voting node:

1. Stop solana on the old machine (voting): `/home/solana/bin/stop.sh`

2. Stop the tower syncing (comment out in crontab): `crontab -e`

3. Sync the tower file: `/home/solana/bin/sync-to-lax.sh` (or `sync-to-nyc.sh`)

Assuming the new node has been and is running in non voting mode then it should already have snapshots (if not follow "rsync all files" below)

4. (a) (on new node) Start the new validator: `/home/solana/bin/change-to-voting.sh`

If the new node has not been running then (on new node) start the voting validator:

4. (b) `/home/solana/bin/start-voting.sh`

Later you can track progress (on new node): `systemctl --user status solana`

You can use the hostnames solana-lax and solana-nyc to refer to the two different hosts

## Rsync all files

If required, rsync all files: 

```
rsync -avh -e ssh --progress --exclude 'rocksdb' /solana/ledger/ solana-lax:/solana/ledger/
```

This should only be done if the node has not been running in hot-standby/non-voting mode.

# Logs

To follow logs: `journalctl --user -u solana -f`

To get logs over a specific time frame : `journalctl --user -u solana --since "<timespec>" --until "<timespec>"`
