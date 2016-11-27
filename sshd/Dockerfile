FROM linyows/consul:0.7
MAINTAINER linyows <linyows@gmail.com>

ENV VAULT_SSH_HELPER_VERSION 0.1.2
ENV VAULT_SSH_HELPER_SHA256 bfe5efd19ea5e0f6b45e60f9631620314a8cbe8e829c6fb3ba7ca6875dc6b37b

RUN apk --no-cache add openssh && \
    curl -sSL https://releases.hashicorp.com/vault-ssh-helper/${VAULT_SSH_HELPER_VERSION}/vault-ssh-helper_${VAULT_SSH_HELPER_VERSION}_linux_amd64.zip \
    -o /tmp/vault_ssh_helper.zip && \
    echo "${VAULT_SSH_HELPER_SHA256}  /tmp/vault_ssh_helper.zip" > /tmp/vault_ssh_helper.sha256 && \
    sha256sum -c /tmp/vault_ssh_helper.sha256 && \
    cd /bin && \
    unzip /tmp/vault_ssh_helper.zip && \
    chmod +x /bin/vault-ssh-helper && \
    rm /tmp/vault_ssh_helper.zip && \
    mkdir /etc/vault-ssh-helper.d

ADD config.hcl /etc/vault-ssh-helper.d/config.hcl
ADD pam.sshd /etc/pam.d/sshd
ADD entry.sh /entry.sh

RUN mkdir /var/run/sshd && \
    chmod +x /entry.sh && \
    sed -ri 's/^SyslogFacility\s+.*/SyslogFacility AUTHPRIV/' /etc/ssh/sshd_config && \
    sed -ri 's/^LogLevel\s+.*/LogLevel VERBOSE/' /etc/ssh/sshd_config && \
    echo "ChallengeResponseAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22 8300 8301 8301/udp 8302 8302/udp 8400 8500 53 53/udp

ENTRYPOINT ["/entry.sh"]
