FROM linyows/consul:agent-0.7
MAINTAINER linyows <linyows@gmail.com>

ENV VAULT_VERSION 0.6.2
ENV VAULT_SHA256 91432c812b1264306f8d1ecf7dd237c3d7a8b2b6aebf4f887e487c4e7f69338c
ENV VAULT_ADDR https://vault.node.consul:8200
ENV VAULT_REDIRECT_ADDR https://vault.node.consul:8200
ENV VAULT_CLUSTER_ADDR https://vault.node.consul:8201
ENV VAULT_SKIP_VERIFY true

ENV COMMON_NAME *.node.consul
ENV KEY_NAME asterisk.node.consul

RUN apk --no-cache add openssl curl ca-certificates \
                       autoconf automake libtool linux-headers alpine-sdk git

RUN curl -sSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    -o /tmp/vault.zip && \
    echo "${VAULT_SHA256}  /tmp/vault.zip" > /tmp/vault.sha256 && \
    sha256sum -c /tmp/vault.sha256 && \
    cd /bin && \
    unzip /tmp/vault.zip && \
    chmod +x /bin/vault && \
    rm /tmp/vault.zip /tmp/vault.sha256

RUN cd /tmp && git clone --depth 1 https://github.com/armon/statsite.git && \
    cd ./statsite && ./autogen.sh && ./configure && make && \
    mv ./statsite /bin/statsite

RUN cd /etc/ssl/private && \
    openssl req -x509 -days 36500 -newkey rsa:2048 -nodes \
    -out $KEY_NAME.crt -keyout $KEY_NAME.key -subj "/C=/ST=/L=/O=/OU=/CN=$COMMON_NAME"

EXPOSE 8125 8200

COPY supervisor.d/statsite.ini /etc/supervisor.d/statsite.ini
COPY supervisor.d/vault.ini /etc/supervisor.d/vault.ini
COPY vault.d /etc/vault.d
COPY vault.conf /etc/vault.conf
