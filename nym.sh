#!/bin/bash

sudo apt update
sudo apt install pkg-config build-essential openssl libssl-dev curl jq git -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
git clone https://github.com/nymtech/nym.git
cd nym
git checkout tags/v0.10.0
cargo build --release

cd target/release
./nym-mixnode init --id winston-smithnode --host $(curl ifconfig.me)
echo "DefaultLimitNOFILE=65535" >> /etc/systemd/system.conf
cat > /etc/systemd/system/nym-mixnode.service <<- EOF
[Unit] 
Description=Nym Mixnode (0.10.0)

[Service]
User=root
ExecStart=/root/nym/target/release/nym-mixnode run --id winston-smithnode
KillSignal=SIGINT # gracefully kill the process when stopping the service. Allows node to unregister cleanly.
Restart=on-failure
RestartSec=30
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nym-mixnode.service
systemctl daemon-reload