# Scripts

## Run pruned node from state-sync
```sh
export HAQQD_DIR="$HOME/.haqqd"
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/run-node-from-state-sync.sh  && \
sh run-node-from-state-sync.sh $HAQQD_DIR
rm run-node-from-state-sync.sh
```

## Run node from pruned snapshot
```sh
export HAQQD_DIR="$HOME/.haqqd"
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/run-node-from-pruned-snapshot.sh  && \
sh run-node-from-pruned-snapshot.sh $HAQQD_DIR
rm run-node-from-pruned-snapshot.sh
```

## Run node from archive snapshot
```sh
export HAQQD_DIR="$HOME/.haqqd"
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/run-node-from-archive-snapshot.sh  && \
sh run-node-from-archive-snapshot.sh $HAQQD_DIR
rm run-node-from-archive-snapshot.sh
```
