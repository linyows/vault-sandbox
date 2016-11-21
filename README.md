Docker Vault
============

vault testing

```
$ docker-compose run -d
$ docker exec -it vault /bin/ash
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
Cluster ID: 113be374-251e-5261-d343-0e76ae713d51

High-Availability Enabled: true
        Mode: active
        Leader: http://127.0.0.1:8200
/ # read -s token
/ # vault auth $token
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

consul-server
-------------

```sh
$ docker run -d --hostname consul --name consul \
    -p 8400:8400 -p 8500:8500 -p 8600:53/udp \
    -v $PWD/consul/server/config:/config \
    linyows/consul:0.7 agent -server -bootstrap -ui-dir /ui -data-dir /tmp/consul -config-dir=/config
```

vault
-----

```sh
$ docker run -d --name vault --hostname vault \
    -p 8200:8200 \
    --link consul:consul \
    -v $PWD/vault/config:/config \
    linyows/vault:0.6 server -config=/config/consul.hcl
```

sshd
----

```sh
docker run -d --name sshd --hostname sshd \
    -p 2222:22 \
    --link vault:vault \
    linyows/sshd-vault:0.1
```

mysql
-----

```sh
docker run -d --name mysql --hostname mysql \
    -p 13306:3306 \
    -e MYSQL_ROOT_PASSWORD=secret \
    library/mysql:5.7
```
