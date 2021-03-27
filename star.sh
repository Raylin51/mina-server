#!/bin/bash
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

docker run --name starcoin -d --network host -v ~/.starcoin/:/root/.starcoin/ starcoin/starcoin:latest /starcoin/starcoin -n barnard --push-server-url http://miner-metrics-pushgw.starcoin.org:9191/ --push-interval 5 --miner-thread 4
docker exec -it starcoin /starcoin/starcoin account list
