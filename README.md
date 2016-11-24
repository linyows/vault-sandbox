Vault Sandbox on Docker
=======================

use docker-compose:

```sh
$ docker-compose run -d
```

use vault client or on mac:

```sh
$ brew install vault
$ export VAULT_ADDR=https://$(docker-machine ip dev):8200
$ export VAULT_SKIP_VERIFY=true
```

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
$ dig @$(docker-machine ip dev) -p 8600 standby.vault.service.consul. SRV +short
$ dig @$(docker-machine ip dev) -p 8600 active.vault.service.consul. SRV +short
1 1 8200 vault.node.dc1.consul.
$ dig @$(docker-machine ip dev) -p 8600 vault.service.consul. +short
vault.node.consul.
172.17.0.4
```

show logs on vault container:

```sh
$ docker exec -it vault /bin/ash
$ tail /tmp/vault.log
$ tail /tmp/consul.log
$ tail /tmp/statsite.log
```

ssh to container:

```sh
$ vault mount ssh
Successfully mounted 'ssh' at 'ssh'!
$ vault write ssh/roles/otp_key_role key_type=otp default_user=ubuntu cidr_list=127.0.0.0/8,172.0.0.0/8,192.0.0.0/8
$ vault write ssh/creds/otp_key_role ip=192.168.99.1
Key             Value
---             -----
lease_id        ssh/creds/otp_key_role/aa0e0fbc-3be4-8ddf-8097-a5cb94cf3126
lease_duration  768h0m0s
lease_renewable false
ip              192.168.99.1
key             a6cbd37f-8522-f86c-1a00-8d44e5de438c
key_type        otp
port            22
username        ubuntu

$ ssh ubuntu@$(docker-machine ip dev) -p 2222
ubuntu@192.168.99.100's password:
Could not chdir to home directory /home/ubuntu: No such file or directory
ubuntu@sshd:/$
```
