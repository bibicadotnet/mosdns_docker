# mosdns_docker

compose.yml

```
services:
  mosdns-x:
    image: bibica/mosdns-x:mod-latest
    container_name: mosdns-x
    restart: always
    environment:
      - TZ=Asia/Ho_Chi_Minh 
    ports:
      - "53:53/tcp"   # TCP
      - "53:53/udp"   # UDP
      - "443:443/tcp" # DOH
      - "443:443/udp" # DOH3
      - "853:853/tcp" # DOT
      - "853:853/udp" # DOQ
    volumes:
      - ./mosdns-x/config:/home/mosdns-x/config
      - ./mosdns-x/log:/home/mosdns-x/log
      - ./mosdns-x/rules:/home/mosdns-x/rules
      - ./mosdns-x/key:/home/mosdns-x/key
      - ./certbot:/home/mosdns-x/ssl:ro  # Mount SSL read-only
    networks:
      reverse_proxy:
        ipv4_address: 172.18.0.6

  certbot:
    image: serversideup/certbot-dns-cloudflare
    container_name: certbot
    restart: always
    environment:
      - TZ=Asia/Ho_Chi_Minh
      - CLOUDFLARE_API_TOKEN=${CLOUDFLARE_API_TOKEN}
      - CERTBOT_EMAIL=${CERTBOT_EMAIL}
      - CERTBOT_DOMAINS=${CERTBOT_DOMAINS}
      - CERTBOT_KEY_TYPE=rsa
    volumes:
      - ./certbot:/etc/letsencrypt

networks:
  reverse_proxy:
    driver: bridge
    name: reverse_proxy
    ipam:
      driver: default
      config:
        - subnet: 172.18.0.0/16
```
