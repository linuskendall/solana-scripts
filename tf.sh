#!/bin/bash

journalctl --user -u solana-rpc -f "$@"
