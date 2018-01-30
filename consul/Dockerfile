FROM alpine:latest
MAINTAINER linyows <linyows@gmail.com>

ENV CONSUL_VERSION 1.0.3
ENV CONSUL_SHA256 4782e4662de8effe49e97c50b1a1233c03c0026881f6c004144cc3b73f446ec5

RUN apk --no-cache add curl ca-certificates bind-tools && \
    curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip \
    -o /tmp/consul.zip && \
    echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 && \
    sha256sum -c /tmp/consul.sha256 && \
    cd /bin && \
    unzip /tmp/consul.zip && \
    chmod +x /bin/consul && \
    rm /tmp/consul.zip /tmp/consul.sha256

EXPOSE 8301 8301/udp
