FROM linyows/consul:0.7
MAINTAINER linyows <linyows@gmail.com>

ENV PYTHON_VERSION=2.7.12-r0
ENV PY_PIP_VERSION=8.1.2-r0
ENV SUPERVISOR_VERSION=3.3.1

ENV VAULT_VERSION 0.6.2
ENV VAULT_SHA256 91432c812b1264306f8d1ecf7dd237c3d7a8b2b6aebf4f887e487c4e7f69338c
ENV VAULT_ADDR=https://vault.node.consul:8200
ENV VAULT_REDIRECT_ADDR=https://vault.node.consul:8200
ENV VAULT_CLUSTER_ADDR=https://vault.node.consul:8201
ENV VAULT_SKIP_VERIFY=true

ENV COMMON_NAME=*.node.consul
ENV KEY_NAME=asterisk.node.consul

RUN apk --no-cache add openssl curl ca-certificates \
                       python=$PYTHON_VERSION py-pip=$PY_PIP_VERSION

RUN pip install --upgrade pip && \
    pip install supervisor==$SUPERVISOR_VERSION

RUN curl -sSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    -o /tmp/vault.zip && \
    echo "${VAULT_SHA256}  /tmp/vault.zip" > /tmp/vault.sha256 && \
    sha256sum -c /tmp/vault.sha256 && \
    cd /bin && \
    unzip /tmp/vault.zip && \
    chmod +x /bin/vault && \
    rm /tmp/vault.zip /tmp/vault.sha256

RUN cd /etc/ssl/private && \
    openssl req -x509 -days 36500 -newkey rsa:2048 -nodes \
    -out $KEY_NAME.crt -keyout $KEY_NAME.key -subj "/C=/ST=/L=/O=/OU=/CN=$COMMON_NAME"

EXPOSE 8125 8200 8300 8301 8301/udp 8302 8302/udp 8400 8500 53 53/udp

VOLUME "/config"

CMD ["supervisord", "--nodaemon", "--configuration", "/config/supervisord.conf"]
