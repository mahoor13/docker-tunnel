# docker-tunnel

A VPN tunnel using Gost (https://gost.run⁠)
Base on https://github.com/go-gost/gost⁠

### Build command

```
docker buildx build . -t gost-ssh-tunnel
```

### Create RSA keys

```
mkdir ./.ssh ; ssh-keygen -t rsa -b 4096 -f ./.ssh/id_rsa ; cat ./.ssh/id_rsa.pub
```

- **Add id_rsa.pub content to the end of server authorized_keys file (~/.ssh/authorized_keys)**

### Sample compose.yaml

```
services:
  tunnel:
    image: gost-ssh-tunnel
    hostname: tunnel
    restart: unless-stopped
    environment:
      - TARGET_HOST=${TARGET_HOST}
      - SSH_CONFIG_FOLDER=${SSH_CONFIG_FOLDER}
      - TUNNEL_PORT=${TUNNEL_PORT}
      - TUNNEL_PROTOCOL=${TUNNEL_PROTOCOL}
      - HTTP_PROXY_PORT=${HTTP_PROXY_PORT}
      - SOCKS_PROXY_PORT=${SOCKS_PROXY_PORT}
    volumes:
      - ./.ssh:${SSH_CONFIG_FOLDER}
    ports:
      - ${HTTP_PROXY_PORT}:${HTTP_PROXY_PORT}
      - ${SOCKS_PROXY_PORT}:${SOCKS_PROXY_PORT}
    networks:
      - net
networks:
  net:
    driver: bridge
```

### Sample .env file (10.10.10.10 is the server IP. Replace it with your desired IP.)

```
TARGET_HOST=10.10.10.10
SSH_CONFIG_FOLDER=/tmp/.ssh
TUNNEL_PORT=20000
TUNNEL_PROTOCOL=socks5
HTTP_PROXY_PORT=8080
SOCKS_PROXY_PORT=2080
```

### Sample gost command to run on the server

```
gost -L socks5://127.0.0.1:20000
```

### Sample service file (/etc/systemd/system/gost.service)

```
[Unit]
Description=This Gost proxy can be use in ssh tunnels like: ssh -N -L :20000:127.0.0.1:20000 10.10.10.10
After=network.target

[Service]
TimeoutStartSec=0
Type=notify
ExecStart=gost -L socks5://127.0.0.1:20000
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

### Enable and Install the service

```
sudo systemctl daemon-reload
sudo systemctl enable --now gost
```
