Vault Sandbox on Docker
=======================

use docker-compose:

```sh
$ docker-compose run -d
```

use vault client or on mac:

```sh
$ brew install vault
$ export VAULT_ADDR=https://$(scripts/hostport --address vaultsandbox_vault_1 8200)
$ export VAULT_SKIP_VERIFY=true
```

Init VAULT
----------

setup:

```sh
/ # vault init
Unseal Key 1: 1/iBMPdC/UIvKl0JvGJHZNjiZSxeEXKbENum0Ota5z4B
Unseal Key 2: NfJJ/+g6z+2zfElftgPH1RbjZyXXK6xHdty79N/rX6oC
Unseal Key 3: fux26+tgpY10g9pDNkR3gRsoL1lxyIIc/WjvY/eJTQQD
Unseal Key 4: KW5ZaKQyIZtLtwVSQf+gzgGh/LhdSyER9z/JFNDZtAsE
Unseal Key 5: YnBmfKdoS/uMSJZOwbgQmgxqtMT7qA9KfIudg/i7pqUF
Initial Root Token: 10283f97-bc50-229e-5771-b4f3f9996457

Vault initialized with 5 keys and a key threshold of 3. Please
securely distribute the above keys. When the Vault is re-sealed,
restarted, or stopped, you must provide at least 3 of these keys
to unseal it again.

Vault does not store the master key. Without at least 3 keys,
your Vault will remain permanently sealed.
/ # vault unseal
Key (will be hidden):
Sealed: true
Key Shares: 5
Key Threshold: 3
Unseal Progress: 1
/ # vault unseal
Key (will be hidden):
Sealed: true
Key Shares: 5
Key Threshold: 3
Unseal Progress: 2
/ # vault unseal
Key (will be hidden):
Sealed: false
Key Shares: 5
Key Threshold: 3
Unseal Progress: 0
/ # vault status
Sealed: false
Key Shares: 5
Key Threshold: 3
Unseal Progress: 0
Version: 0.6.2
Cluster Name: vault-cluster-6f314143
Cluster ID: f9b4c398-889b-902a-c652-65368999a46a

High-Availability Enabled: true
        Mode: active
        Leader: https://vault.node.consul:8200
/ # vault auth
Key (will be hidden):
Successfully authenticated! You are now logged in.
token: 10283f97-bc50-229e-5771-b4f3f9996457
token_duration: 0
token_policies: [root]
/ # vault mounts
Path        Type       Default TTL  Max TTL  Description
cubbyhole/  cubbyhole  n/a          n/a      per-token private secret storage
secret/     generic    system       system   generic secret storage
sys/        system     n/a          n/a      system endpoints used for control, policy and debugging
```

show dns for vault with consul:

```sh
$ dig @$(docker-machine ip $DOCKER_MACHINE_NAME) -p $(scripts/hostport vaultsandbox_consul_1 8600) standby.vault.service.consul. SRV +short
$ dig @$(docker-machine ip $DOCKER_MACHINE_NAME) -p $(scripts/hostport vaultsandbox_consul_1 8600) active.vault.service.consul. SRV +short
1 1 8200 vault.node.dc1.consul.
$ dig @$(docker-machine ip $DOCKER_MACHINE_NAME) -p $(scripts/hostport vaultsandbox_consul_1 8600) vault.service.consul. +short
vault.node.consul.
172.17.0.4
```

SSH
---

ssh to container

```sh
$ vault mount ssh
Successfully mounted 'ssh' at 'ssh'!
$ vault write ssh/roles/otp_ops key_type=otp default_user=ops cidr_list=127.0.0.0/8,172.0.0.0/8,192.0.0.0/8
```

manualy:

```sh
$ vault write ssh/creds/otp_ops ip=192.168.99.1
Key             Value
---             -----
lease_id        ssh/creds/otp_key_role/aa0e0fbc-3be4-8ddf-8097-a5cb94cf3126
lease_duration  768h0m0s
lease_renewable false
ip              192.168.99.1
key             a6cbd37f-8522-f86c-1a00-8d44e5de438c
key_type        otp
port            22
username        ops

$ ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
  ops@$(docker-machine ip $DOCKER_MACHINE_NAME) -p $(scripts/hostport vaultsandbox_sshd_ubuntu_1 22)
ops@192.168.99.100's password:
ops@sshd:/$
```

auto:

```sh
$ brew install http://git.io/sshpass.rb
$ vault ssh -roletp_ops -strict-host-key-checking=no \
  ops@$(docker-machine ip $DOCKER_MACHINE_NAME) -p $(scripts/hostport vaultsandbox_sshd_centos_1 22)
```

MySQL
-----

```sh
$ vault write mysql/config/connection connection_url="root:root@tcp(mysql:3306)/"
The following warnings were returned from the Vault server:
* Read access to this endpoint should be controlled via ACLs as it will return the connection URL as it is, including passwords, if any.
$ vault write mysql/config/lease lease=10m lease_max=1h
Success! Data written to: mysql/config/lease
$ vault write mysql/roles/readonly \
  sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';"
Success! Data written to: mysql/roles/readonly
$ vault read mysql/creds/readonly
Key             Value
---             -----
lease_id        mysql/creds/readonly/f94298b8-eb3f-9b92-e21b-d2de2f283b82
lease_duration  30m0s
lease_renewable true
password        61a1e30a-3883-a3bd-b30f-82d96bb68db7
username        read-root-f32607
# mysql -uread-root-f32607 -hmysql -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.16 MySQL Community Server (GPL)
Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.
```
