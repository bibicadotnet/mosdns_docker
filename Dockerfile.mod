FROM alpine:latest
ARG TARGETARCH
RUN apk add --no-cache curl unzip ca-certificates tzdata && \
    case "${TARGETARCH}" in \
        amd64)  MOSDNS_ARCH="amd64" ;; \
        arm64)  MOSDNS_ARCH="arm64" ;; \
        arm/v7) MOSDNS_ARCH="armv7" ;; \
        *) exit 1 ;; \
    esac && \
    LATEST=$(curl -s https://api.github.com/repos/bibicadotnet/mosdns-x/releases/latest | sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p') && \
    curl -sL "https://github.com/bibicadotnet/mosdns-x/releases/download/${LATEST}/mosdns-linux-${MOSDNS_ARCH}.zip" -o /tmp/mosdns.zip && \
    mkdir -p /home/mosdns-x && \
    unzip -qo /tmp/mosdns.zip -d /home/mosdns-x && \
    chmod +x /home/mosdns-x/mosdns && \
    rm -f /usr/local/bin/mosdns && \
    apk del curl unzip && \
    rm -rf /tmp/mosdns.zip /var/cache/apk/*

RUN addgroup -g 65534 -S nogroup || true && \
    adduser -u 65534 -G nogroup -S -s /bin/sh nobody || true
WORKDIR /home/mosdns-x
EXPOSE 53/tcp 53/udp 443/tcp 443/udp 853/tcp 853/udp 8090/tcp 8090/udp

CMD ["/home/mosdns-x/mosdns", "start", "-c", "/home/mosdns-x/config/config.yaml", "-d", "/home/mosdns-x"]
