## Run a proof of stake network on Deneb fork (Geth 1.14.6 and Prysm 5.0.4)

1. Initialise geth and prysm using `./run-init.sh`
2. Run the nodes `./run-nodes.sh`

This uses two validators - you can edit that number in both scripts.

## Notes
* The Prysm docs for running a [Proof of Stake Devnet](https://docs.prylabs.network/docs/advanced/proof-of-stake-devnet) are out of date.
    * You need to add `ELECTRA_FORK_VERSION: 0x20000094` to your `config.yml`
    * The `genesis.json` provided doesn't work with the deneb fork, so use the one given in this repo.
* You need to start from the `genesis-initial.json` which is why we copy it into `genesis.json` as it is overwritten on each run.
* The order of arguments for generating prysm `genesis.ssz` is extremely specific.
* The geth, prysm and validator clients must be run from the same script to work and in the specific order. Discord thread [here](https://discord.com/channels/476244492043812875/1255607182259650822/1256190759221203056)
* Geth takes ~6 minutes to get past the `Nil finalized block cannot evict old blobs` errors.
* Executables were compiled using the following commands and then deleting the source code: 

```shell
git clone https://github.com/prysmaticlabs/prysm && cd prysm
go build -o=../beacon-chain ./cmd/beacon-chain
go build -o=../validator ./cmd/validator
go build -o=../prysmctl ./cmd/prysmctl
cd ..
```

```shell
git clone https://github.com/ethereum/go-ethereum && cd go-ethereum
make geth
cp ./build/bin/geth ../geth
cd ..
```

## Errors
Hit these countless times trying to get this to work. 
### Validator
```shell
error="rpc error: code = Internal desc = could not build block in parallel: rpc error: code = Internal desc = Could not get local payload: could not prepare payload: payload status is SYNCING or ACCEPTED" prefix=client pubkey=0xa99a76ed7796 slot=9
```
### Beacon Nodes
```shell
Unable to retrieve proof-of-stake genesis block data
```
### Geth
```shell
WARN [06-28|14:55:59.270] Forkchoice requested unknown head        hash=1a6c12..a2e9d0
WARN [06-28|14:56:11.233] Forkchoice requested unknown head        hash=1a6c12..a2e9d0 
```

Successful logs are included so you have a reference to work from. 
