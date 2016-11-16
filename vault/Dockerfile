FROM alpine:latest
MAINTAINER linyows <linyows@gmail.com>

ENV VAULT_VERSION 0.6.2
ENV VAULT_SHA256 91432c812b1264306f8d1ecf7dd237c3d7a8b2b6aebf4f887e487c4e7f69338c

RUN apk --no-cache add openssl curl ca-certificates && \
    curl -sSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o /tmp/vault.zip && \
    echo "${VAULT_SHA256}  /tmp/vault.zip" > /tmp/vault.sha256 && \
    sha256sum -c /tmp/vault.sha256 && \
    cd /bin && \
    unzip /tmp/vault.zip && \
    chmod +x /bin/vault && \
    rm /tmp/vault.zip

EXPOSE 8200
VOLUME "/config"

ENTRYPOINT ["/bin/vault"]
CMD ["server", "-dev-listen-address=0.0.0.0:8200", "-dev"]
