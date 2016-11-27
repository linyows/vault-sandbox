FROM alpine:latest
MAINTAINER linyows <linyows@gmail.com>

ENV CONSUL_VERSION 0.7.1
ENV CONSUL_SHA256 5dbfc555352bded8a39c7a8bf28b5d7cf47dec493bc0496e21603c84dfe41b4b

RUN apk --no-cache add curl ca-certificates bind-tools && \
    curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip \
    -o /tmp/consul.zip && \
    echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 && \
    sha256sum -c /tmp/consul.sha256 && \
    cd /bin && \
    unzip /tmp/consul.zip && \
    chmod +x /bin/consul && \
    rm /tmp/consul.zip /tmp/consul.sha256

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53 53/udp
