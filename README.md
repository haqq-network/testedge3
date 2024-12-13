# Haqq Network - TestEdge3

## Overview
The current version of the HAQQ TestEdge3 is [`v1.8.1`](https://github.com/haqq-network/haqq/releases/tag/v1.8.1).

_*Battle tested on [Ubuntu LTS 22.04](https://spinupwp.com/doc/what-does-lts-mean-ubuntu/#:~:text=The%20abbreviation%20stands%20for%20Long,extended%20period%20over%20regular%20releases)*_

## Prerequisites
- [Required Packages are installed](#packages-installation)
- [`Go 1.22+` is installed](#go-installation)
  - [Manual Installation](https://www.digitalocean.com/community/tutorials/how-to-install-go-on-ubuntu-20-04)
  - [Installation via Script](#go-installation)

## Haqq TestEdge3 node installation guide
_*All methods can be used, depending on preference or requirement.*_
### Easy go script methods
- [Run pruned node from state-sync](#snapshot)
- [Run pruned node from snapshot](#snapshot)
- [Run archive node from snapshot](#snapshot)
### Manual method
- [Binary installation](#binary-installation)
  - [Download pre-compiled binary for required arch](https://github.com/haqq-network/haqq/releases/tag/v1.8.1)
  - [Build from source](#build-binary-from-source)
- [Initialize node](#initialize-node)
- [Download genesis](#download-genesis)
- [Node bootstrap](#node-bootstrap)
  - [State-sync method](#state-sync)
  - [Snapshot method](#snapshot)
    - [Pruned](#pruned-snapshot-download)
    - [Archive](#archive-snapshot-download)
- [Launch node](#launch-node)
  - [Run binary](#run-haqq-bin)
  - [Cosmovisor](#cosmovisor-setup)

## Packages installation

```sh
sudo apt-get update && \
sudo apt-get install curl git make gcc liblz4-tool build-essential git-lfs jq aria2 -y
```

## Go installation

```sh
curl -OL https://raw.githubusercontent.com/haqq-network/testedge3/master/install_go.sh && \
sh install_go.sh && \ 
source $HOME/.bash_profile
```

## Binary installation
*_Binary can be downloaded from [haqq official repository](https://github.com/haqq-network/haqq/releases) or builded from source._*

### Download pre-compiled binary for required arch
- Download latest binary for your arch: </br>
https://github.com/haqq-network/haqq/releases/tag/v1.8.1

### Build binary from source
- Clone the repo and build the binary:
```sh
cd $HOME
git clone -b v1.8.1 https://github.com/haqq-network/haqq
cd haqq
make install
```

- Verify binary version:
```sh
haqq@haqq-node:~# haqqd -v
haqqd version "1.8.1" 32131e743799979c7317c2a394e008e74f06ba7e
```

## Initialize node

```sh
export CUSTOM_MONIKER="testedge3_node"
export HAQQD_DIR="$HOME/.haqqd"

haqqd config chain-id haqq_53211-3 && \
haqqd init $CUSTOM_MONIKER --chain-id haqq_53211-3
```
## Download genesis
```sh
curl -L https://raw.githubusercontent.com/haqq-network/testedge3/master/genesis.json -o $HAQQD_DIR/config/genesis.json
```

## Node bootstrap
*_Node can be bootstrapped using [snapshot](https://pub-d737aae8c5d74559afafae6b5db96c99.r2.dev/index.html) or state-sync._*
### State-sync
```sh
curl -OL https://raw.githubusercontent.com/haqq-network/testedge3/master/state_sync.sh && \
chmod +x state_sync.sh && \
./state_sync.sh $HAQQD_DIR
```
### Snapshot
- Configure seeds:
```sh
sed -i 's/seeds = ".*"/seeds = "5fa53a57f11ab3f1979df6cdd572a2cc6c519f5a@peer1.testedge3.haqq.network:26656,3baf1dedfebb985974c2c15d246aa6c821da1cf6@peer2.testedge3.haqq.network:26666,64dcbb5cf8b8b9f7c950bfa1a3eee339e98c94ca@peer3.testedge3.haqq.network:26676"/' $HAQQD_DIR/config/config.toml
```
#### Pruned snapshot download 
```sh
curl -o - -L $(curl -s "https://pub-d737aae8c5d74559afafae6b5db96c99.r2.dev/index.json" | jq -r .pruned[0].link) | lz4 -c -d - | tar -x -C $HAQQD_DIR
```
#### Archive snapshot download
```sh
curl -o - -L $(curl -s "https://pub-d737aae8c5d74559afafae6b5db96c99.r2.dev/index.json" | jq -r .archive[0].link) | lz4 -c -d - | tar -x -C $HAQQD_DIR
```

## Launch node
*_Node can be launched through a binary directly or a cosmovisor can be used._*
### Run haqq bin
```sh
haqqd start
```
### Cosmovisor setup
- Install cosmovisor binary:
```sh
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest
```

- Create Cosmovisor folders and load the node binary:
```sh
mkdir -p $HAQQD_DIR/cosmovisor/genesis/bin && \
mkdir -p $HAQQD_DIR/cosmovisor/upgrades
cp $HOME/go/bin/haqqd $HAQQD_DIR/cosmovisor/genesis/bin
```

- Create haqqd cosmovisor service:
```sh
sudo nano /etc/systemd/system/haqqd.service
```

```sh
[Unit]
Description="haqqd cosmovisor"
After=network-online.target

[Service]
User=<your user>
ExecStart=/home/<your user>/go/bin/cosmovisor run start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=haqqd"
Environment="DAEMON_HOME=$HAQQD_DIR"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=false"

[Install]
WantedBy=multi-user.target
```

- Enable and start service:

```sh
sudo systemctl enable haqqd.service && \
sudo systemctl start haqqd.service
```

- Check cosmovisor logs:
```sh
sudo journalctl --system -fu haqqd
```
