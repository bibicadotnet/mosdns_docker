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
    unzip -qo /tmp/mosdns.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/mosdns && \
    apk del curl unzip && \
    rm -rf /tmp/mosdns.zip /var/cache/apk/*
WORKDIR /home/mosdns-x
EXPOSE 53/tcp 53/udp 853/tcp 853/udp 8090/tcp 8090/udp
CMD ["mosdns", "start", "-c", "/home/mosdns-x/config/config.yaml", "-d", "/home/mosdns-x"]
