#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

SOLANA_URL=http://localhost:8899

LEDGER_DIR=${1:-/solana/ledger}
CURRENT_SLOT=$(solana slot --url ${SOLANA_URL})

solana-ledger-tool create-snapshot --ledger ${LEDGER_DIR} ${CURRENT_SLOT} . 
#${LEDGER_DIR}
