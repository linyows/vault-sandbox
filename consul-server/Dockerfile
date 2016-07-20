FROM alpine:latest
MAINTAINER linyows <linyows@gmail.com>

ENV CONSUL_VERSION 0.6.4
ENV GLIBC_VERSION "2.23-r1"
ENV DNS_RESOLVES consul
ENV DNS_PORT 8600

RUN apk --update add curl ca-certificates && \
    curl -Ls https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk > /tmp/glibc-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk && \
    rm -rf /tmp/glibc-${GLIBC_VERSION}.apk /var/cache/apk/*

RUN wget -qO /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
      unzip -d /bin /tmp/consul.zip && rm /tmp/consul.zip && chmod 755 /bin/consul

ADD ./config /config/

ENTRYPOINT ["/bin/consul", "agent", "-server", "-config-dir=/config"]
