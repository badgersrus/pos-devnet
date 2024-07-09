#!/bin/bash

rm -rf gethdata
rm -rf beacondata
rm -rf validatordata

prysm_logs="$(pwd)/logs"

echo -e "\n\n" | ./geth --datadir=gethdata account import pk.txt
echo "Private key imported"


./geth --datadir=gethdata init genesis.json
echo "Geth genesis initialized"

./geth --http \
       --http.api eth,net,web3 \
       --ws --ws.api eth,net,web3 \
       --authrpc.jwtsecret jwt.hex \
       --datadir gethdata \
       --nodiscover \
       --syncmode full \
       --allow-insecure-unlock \
       --unlock 0x123463a4b065722e99115d6c222f267d9cabb524 \
       --password password.txt > "${prysm_logs}/geth.log" 2>&1 &

sleep 3
echo "Geth network started"

./prysmctl testnet generate-genesis \
           --fork deneb \
           --num-validators 2 \
           --genesis-time-delay 600 \
           --chain-config-file config.yml \
           --geth-genesis-json-in genesis.json \
           --geth-genesis-json-out genesis.json \
           --output-ssz genesis.ssz
sleep 3

# Run the Prysm beacon node
./beacon-chain --datadir beacondata \
               --min-sync-peers 0 \
               --genesis-state genesis.ssz \
               --bootstrap-node= \
               --interop-eth1data-votes \
               --chain-config-file config.yml \
               --contract-deployment-block 0 \
               --chain-id 32382 \
               --rpc-host=127.0.0.1 \
               --rpc-port=4000 \
               --accept-terms-of-use \
               --jwt-secret jwt.hex \
               --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 \
               --minimum-peers-per-subnet 0 \
               --enable-debug-rpc-endpoints \
               --verbosity=debug \
               --execution-endpoint gethdata/geth.ipc > "${prysm_logs}/beacon-chain.log" 2>&1 &

echo "Beacon node started"

# Run Prysm validator client
./validator --beacon-rpc-provider=127.0.0.1:4000 \
            --datadir validatordata \
            --accept-terms-of-use \
            --interop-num-validators 2 \
            --chain-config-file config.yml > "${prysm_logs}/validator.log" 2>&1 &

echo "Validator client started"

echo "Running ..."