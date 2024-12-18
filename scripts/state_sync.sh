#!/usr/bin/env bash
set -euo pipefail

# Check if a haqqd directory provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <haqqd_directory>"
  exit 1
fi

# Define the Tendermint RPC endpoint's of the HAQQ network
SNAP_RPC1="https://rpc.tm.archive.testedge3.haqq.network:443"
SNAP_RPC2="https://rpc.tm.archive.testedge3.haqq.network:443"

# Select one available SNAP_RPC
if curl -Is "$SNAP_RPC1/health" | head -n 1 | grep "200" > /dev/null; then
  echo "[INFO] SNAP_RPC1 ($SNAP_RPC1) is available and selected for requests"
  SNAP_RPC=$SNAP_RPC1
elif curl -Is "$SNAP_RPC2/health" | head -n 1 | grep "200" > /dev/null; then
  echo "[INFO] SNAP_RPC2 ($SNAP_RPC2) is available and selected for requests"
  SNAP_RPC=$SNAP_RPC2
else
  echo "[ERROR] Both SNAP_RPC1 and SNAP_RPC2 are not available. Exiting..."
  exit 1
fi

SNAP_RPC=$SNAP_RPC2

# Retrieve the latest block height of the HAQQ network
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)

# Calculate the height of the block to be trusted
BLOCK_HEIGHT=$((LATEST_HEIGHT - 10000))

# Retrieve the hash of the block to be trusted
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Define persistent peers
P_PEERS=""

# Define seed nodes
SEEDS="5fa53a57f11ab3f1979df6cdd572a2cc6c519f5a@peer1.testedge3.haqq.network:26656,3baf1dedfebb985974c2c15d246aa6c821da1cf6@peer2.testedge3.haqq.network:26666,64dcbb5cf8b8b9f7c950bfa1a3eee339e98c94ca@peer3.testedge3.haqq.network:26676"

# Modify the HAQQ configuration file to add the trusted block and other parameters
sed -i.bak \
  -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
      s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
      s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
      s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
      s|^(persistent_peers[[:space:]]+=[[:space:]]+).*$|\1\"$P_PEERS\"| ; \
      s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEEDS\"|" \
  $1/config/config.toml

# Print a message indicating that the configuration file has been updated
echo "HAQQ configuration file updated with the trusted block $BLOCK_HEIGHT ($TRUST_HASH)"
