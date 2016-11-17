FROM alpine:latest
MAINTAINER linyows <linyows@gmail.com>

ENV VAULT_SSH_HELPER_VERSION 0.1.2
ENV VAULT_SSH_HELPER_SHA256 bfe5efd19ea5e0f6b45e60f9631620314a8cbe8e829c6fb3ba7ca6875dc6b37b

RUN apk --no-cache add openssh openssl curl ca-certificates && \
    curl -sSL https://releases.hashicorp.com/vault-ssh-helper/${VAULT_SSH_HELPER_VERSION}/vault-ssh-helper_${VAULT_SSH_HELPER_VERSION}_linux_amd64.zip -o /tmp/vault_ssh_helper.zip && \
    echo "${VAULT_SSH_HELPER_SHA256}  /tmp/vault_ssh_helper.zip" > /tmp/vault_ssh_helper.sha256 && \
    sha256sum -c /tmp/vault_ssh_helper.sha256 && \
    cd /bin && \
    unzip /tmp/vault_ssh_helper.zip && \
    chmod +x /bin/vault-ssh-helper && \
    rm /tmp/vault_ssh_helper.zip && \
    mkdir /etc/vault-ssh-helper.d && \
    ssh-keygen -A && \
    echo "root:root" | chpasswd

EXPOSE 22

ADD ./config.hcl /etc/vault-ssh-helper.d/config.hcl
ADD ./pam.sshd /etc/pam.d/sshd
ADD ./sshd_config /etc/ssh/sshd_config

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
