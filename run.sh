#!/bin/bash

rm -rf gethdata
rm -rf beacondata
rm -rf validatordata

echo -e "\n\n" | ./geth --datadir=gethdata account import pk.txt
echo "Private key imported"


./geth --datadir=gethdata init genesis.json
echo "Geth genesis initialized"

./prysmctl testnet generate-genesis \
           --fork deneb \
           --num-validators 2 \
           --genesis-time-delay 10 \
           --chain-config-file config.yml \
           --geth-genesis-json-in genesis.json \
           --geth-genesis-json-out genesis.json \
           --output-ssz genesis.ssz
sleep 3
