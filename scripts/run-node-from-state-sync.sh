#!/bin/bash
# All-in-one Bash script for starting a Haqq node on Ubuntu LTS 22.04

# Check if a custom moniker is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <custom_moniker>"
  exit 1
fi

# Use the provided custom moniker
CUSTOM_MONIKER="$1"
HAQQD_DIR="$HOME/.haqqd"

echo "###############################################"
echo "Updating and installing required packages..."
echo "###############################################"

# Update and install required packages
sudo apt-get update -qq
sudo apt-get install -qq curl git make gcc liblz4-tool build-essential jq -y

echo "###############################################"
echo "Installing Go language..."
echo "###############################################"

# Install Go language
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/install_go.sh
sh install_go.sh
rm install_go.sh

echo "Sourcing the Go environment variables..."
# Source the Go environment variables
. $HOME/.bash_profile

echo "###############################################"
echo "Installing the HAQQ node..."
echo "###############################################"

# Install the Haqq node
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/install_haqq.sh
sh install_haqq.sh
rm install_haqq.sh

echo "###############################################"
echo "Initializing and starting the Haqq node..."
echo "###############################################"

# Initialize and start the Haqq node
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/init_start.sh
sh init_start.sh $CUSTOM_MONIKER $HAQQD_DIR
rm init_start.sh

# Setup state-sync for the Haqq node
echo "###############################################"
echo "Setup state-sync for the Haqq node..."
echo "###############################################"
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/state_sync.sh
chmod +x state_sync.sh
./state_sync.sh $HAQQD_DIR
rm state_sync.sh

# Haqq node start
haqqd start
