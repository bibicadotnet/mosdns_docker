# mosdns_docker
```
services:
  mosdns-x:
    image: bibica/mosdns-x
    container_name: mosdns-x
    restart: always
    environment:
      - TZ=Asia/Ho_Chi_Minh
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "853:853/tcp"
      - "853:853/udp"
    volumes:
      - ./mosdns-x/config:/home/mosdns-x/config:ro
      - ./mosdns-x/log:/home/mosdns-x/log
    networks:
      reverse_proxy:
        ipv4_address: 172.18.0.6
    logging:
      driver: "none"

networks:
  reverse_proxy:
    driver: bridge
    name: reverse_proxy
    ipam:
      driver: default
      config:
        - subnet: 172.18.0.0/16
```
