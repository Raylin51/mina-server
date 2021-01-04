#!/bin/bash

apt-get update
apt-get install sudo
apt-get install apt-transport-https
echo "deb [trusted=yes] http://packages.o1test.net release main" | sudo tee /etc/apt/sources.list.d/mina.list
sudo apt-get update
sudo apt-get install -y curl unzip mina-testnet-postake-medium-curves=0.2.2-b7eff8e --allow-downgrades
mkdir ~/keys
wget -O ~/peers.txt https://raw.githubusercontent.com/MinaProtocol/coda-automation/bug-bounty-net/terraform/testnets/testworld/peers.txt
touch ~/.mina-env
