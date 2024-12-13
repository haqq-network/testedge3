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

# Configure seeds
sed -i 's/seeds = ".*"/seeds = "5fa53a57f11ab3f1979df6cdd572a2cc6c519f5a@peer1.testedge3.haqq.network:26656,3baf1dedfebb985974c2c15d246aa6c821da1cf6@peer2.testedge3.haqq.network:26666,64dcbb5cf8b8b9f7c950bfa1a3eee339e98c94ca@peer3.testedge3.haqq.network:26676"/' $HAQQD_DIR/config/config.toml

# Download archive snapshot for the Haqq node
echo "###############################################"
echo "Downloading archive snapshot for the Haqq node..."
echo "###############################################"
curl -o - -L $(curl -s "https://pub-d737aae8c5d74559afafae6b5db96c99.r2.dev/index.json" | jq -r .archive[0].link) | lz4 -c -d - | tar -x -C $HAQQD_DIR
# Haqq node start
haqqd start
