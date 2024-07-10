#!/bin/bash

pkill geth
pkill beacon-chain

rm -rf gethdata
rm -rf beacondata
rm -rf validatordata

cp genesis-initial.json genesis.json

./prysmctl testnet generate-genesis \
           --fork deneb \
           --num-validators 2 \
	         --genesis-time-delay 30 \
           --chain-config-file config.yml \
           --geth-genesis-json-in genesis.json \
	         --output-ssz genesis.ssz \
	          --geth-genesis-json-out genesis.json

sleep 1
echo "Prysm genesis generated"

echo -e "\n\n" | ./geth --datadir=gethdata account import pk.txt
echo "Private key imported"

./geth --datadir=gethdata init genesis.json
sleep 1
echo "Geth genesis initialized"
