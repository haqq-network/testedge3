# Easy go script methods
## Run pruned node from state-sync

### Parameters
| File          | Parameter               | Value        | Description                                  |
|---------------|-------------------------|--------------|----------------------------------------------|
| `app.toml`    | `pruning`               | `custom`     | Pruning strategy.                            |
| `app.toml`    | `pruning-keep-recent`   | `100`        | Number of recent states to keep.             |
| `app.toml`    | `pruning-interval`      | `10`         | Frequency of pruning.                        |
| `app.toml`    | `min-retain-blocks`     | `100`        | Minimum block height offset from the current.|
| `config.toml` | `indexer`               | `null`       | Disables the transaction indexer.            |

### Commands to execute
```sh
export HAQQD_DIR="$HOME/.haqqd"
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/run-node-from-state-sync.sh  && \
sh run-node-from-state-sync.sh $HAQQD_DIR
rm run-node-from-state-sync.sh
```

## Run node from pruned snapshot

### Parameters
| File          | Parameter               | Value        | Description                                  | 
|---------------|-------------------------|--------------|----------------------------------------------|
| `app.toml`    | `pruning`               | `custom`     | Pruning strategy.                            |
| `app.toml`    | `pruning-keep-recent`   | `100`        | Number of recent states to keep.             |
| `app.toml`    | `pruning-interval`      | `10`         | Frequency of pruning.                        |
| `app.toml`    | `min-retain-blocks`     | `100`        | Minimum block height offset from the current.|
| `config.toml` | `indexer`               | `null`       | Disables the transaction indexer.            |

### Commands to execute
```sh
export HAQQD_DIR="$HOME/.haqqd"
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/run-node-from-pruned-snapshot.sh  && \
sh run-node-from-pruned-snapshot.sh $HAQQD_DIR
rm run-node-from-pruned-snapshot.sh
```

## Run node from archive snapshot
### Parameters
| File          | Parameter               | Value        | Description                       |
|---------------|-------------------------|--------------|-----------------------------------|
| `app.toml`    | `pruning`               | `nothing`    | Pruning strategy.                 |
| `app.toml`    | `pruning-keep-recent`   | `0`          | Number of recent states to keep.  |
| `app.toml`    | `pruning-interval`      | `0`          | Frequency of pruning.             |
| `app.toml`    | `enable-indexer`        | `true`       | Enables the EVM indexer           |
| `config.toml` | `indexer`               | `kv`         | Enables the transaction indexer.  |

### Commands to execute
```sh
export HAQQD_DIR="$HOME/.haqqd"
curl -OsL https://raw.githubusercontent.com/haqq-network/testedge3/master/scripts/run-node-from-archive-snapshot.sh  && \
sh run-node-from-archive-snapshot.sh $HAQQD_DIR
rm run-node-from-archive-snapshot.sh
```
