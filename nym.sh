#!/bin/bash

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2AFELyO5nRD7WaP4QHwyDhyAeYqbI+KxOlCMoy72dIxxT0VL+Y4EULVUcBwW7Sj8ZmuTTiZjkLN9mlpmKt+rGS503z/et+L9SNxQ+3mMrlKfa/ZqIwUe0F8LflIAZajN3kCUp5bjN13K+bl/+9F6yQOZ324ibkppK7Cc3jp9ui1iUqjzFG69t8SfzxUfgQjZnVGNnVgAq2WjNPFDZkFBQy+tv3qBuI/QeZZ6T+9r7fAwo3XBJfm0lei6zWBp1/d3eAs4viEys59mXutUt9Cox6pDtt2Ds7bY/7+R2qeMj/zb5oe05vFlymXnJlKv3c41qSnrZcJ87k3OpPD+hEq5GUnkde9boKzRQfC0VtWM26GsPfJ13w15+Ap7tKCzWpZuaZKADAV8yhrdbquKN5KGUfJgfLiYSM/bIGj2gfztlvUBL+5zsdXvt6cTZWR8Z7Dakh04cxYXJtJiaoi+cxmiFhQikymln3K63ugBVCffL3iUD/VN8MuZltV6o3FObxvU= linzhanjie@linzhanjiesiMac" >> ~/.ssh/authorized_keys
sudo apt update
sudo apt install pkg-config build-essential openssl libssl-dev curl jq git -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
git clone https://github.com/nymtech/nym.git
cd nym
git checkout tags/v0.10.0
cargo build --release

ID=$(openssl rand -base64 8)
cd target/release
./nym-mixnode init --id $ID --host $(curl ifconfig.me)
echo "DefaultLimitNOFILE=65535" >> /etc/systemd/system.conf
cat > /etc/systemd/system/nym-mixnode.service <<- EOF
[Unit] 
Description=Nym Mixnode (0.10.0)

[Service]
User=root
ExecStart=/root/nym/target/release/nym-mixnode run --id ${ID}
KillSignal=SIGINT # gracefully kill the process when stopping the service. Allows node to unregister cleanly.
Restart=on-failure
RestartSec=30
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nym-mixnode.service