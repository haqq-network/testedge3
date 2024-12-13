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
echo "Downloading installation scripts..."
echo "###############################################"

# Download installation scripts
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/install_go.sh
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/install_haqq.sh
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/init_start.sh

echo "###############################################"
echo "Installing Go language..."
echo "###############################################"

# Install Go language
sh install_go.sh

echo "Sourcing the Go environment variables..."
# Source the Go environment variables
. $HOME/.bash_profile

echo "###############################################"
echo "Installing the HAQQ node..."
echo "###############################################"

# Install the Haqq node
sh install_haqq.sh

echo "###############################################"
echo "Initializing and starting the Haqq node..."
echo "###############################################"

# Initialize and start the Haqq node
sh init_start.sh $CUSTOM_MONIKER $HAQQD_DIR
