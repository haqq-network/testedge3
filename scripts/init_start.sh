#!/bin/bash

# Check if a custom moniker is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <custom_moniker>"
  exit 1
fi

# Use the provided custom moniker
CUSTOM_MONIKER="$1"
HAQQD_DIR="$HOME/.haqqd"

# Set the chain ID
haqqd config chain-id haqq_53211-3

# Initialize the node with your custom moniker and chain ID
haqqd init $CUSTOM_MONIKER --chain-id haqq_53211-3

# Download the genesis file for mainnet(haqq_11235-1)
curl -OL https://raw.githubusercontent.com/haqq-network/testedge3/master/genesis.json && \
mv genesis.json $HAQQD_DIR/config/genesis.json

# Configure State sync
curl -OL https://raw.githubusercontent.com/haqq-network/testedge3/master/state_sync.sh && \
sh state_sync.sh $HAQQD_DIR

# Start Haqq
haqqd start
