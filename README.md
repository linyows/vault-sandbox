Vault Sandbox on Docker
=======================

use docker-compose:

```sh
$ docker-compose up -d
```

use vault client or on mac:

```sh
$ brew install vault
$ export VAULT_ADDR=https://localhost:18200
$ export VAULT_SKIP_VERIFY=true
```

Init VAULT
----------

setup:

```sh
Init file: /var/folders/js/frg3ythj7xd8llf35_5g96c80000gp/T/tmp.F1Azy8ZJ
Key                Value
---                -----
Seal Type          shamir
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       9cc9bb16-0ded-9e17-0554-8b3dff823584
Version            0.9.3
HA Enabled         true
HA Mode            sealed
Key                Value
---                -----
Seal Type          shamir
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       9cc9bb16-0ded-9e17-0554-8b3dff823584
Version            0.9.3
HA Enabled         true
HA Mode            sealed
Key             Value
---             -----
Seal Type       shamir
Sealed          false
Total Shares    5
Threshold       3
Version         0.9.3
Cluster Name    vault-cluster-9f700538
Cluster ID      0a69f6ba-dc13-016f-b823-8c0b577fb1e8
HA Enabled      true
HA Mode         active
HA Cluster      https://vault.node.consul:8201
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                Value
---                -----
token              500fc43c-8bc1-5f76-aed7-17fc778d1039
token_accessor     b9fdf1a2-3b63-f122-e277-ba5cb3a854c8
token_duration     ∞
token_renewable    false
token_policies     [root]
Success! Enabled the file audit device at: file/
Success! Data written to: ssh/roles/otp_ops
Success! Enabled the database secrets engine at: database/
```

### Consul DNS

show dns for vault with consul:

```sh
$ dig standby.vault.service.consul. SRV +short @localhost -p 10053
$ dig active.vault.service.consul. SRV +short @localhost -p 10053
1 1 8200 vault.node.dc1.consul.
$ dig vault.service.consul. +short @localhost -p 10053
vault.node.consul.
172.17.0.4
```

SSH
---

ssh to container

```sh
$ vault secrets enable ssh
Success! Enabled the ssh secrets engine at: ssh/
$ vault write ssh/roles/otp_ops key_type=otp default_user=ops cidr_list=127.0.0.0/8,172.0.0.0/8,192.0.0.0/8
```

manualy:

```sh
$ vault write ssh/creds/otp_ops ip=127.0.0.1 port=10022
zsh: correct 'ssh/creds/otp_ops' to 'sshd/creds/otp_ops' [nyae]? n
Key                Value
---                -----
lease_id           ssh/creds/otp_ops/20774dee-d22e-a795-b83a-570d1484fff7
lease_duration     768h
lease_renewable    false
ip                 127.0.0.1
key                8f7cb10b-9658-e571-48bc-c8468c8508af
key_type           otp
port               22
username           ops

$ ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ops@localhost -p 10022
Warning: Permanently added '[localhost]:10022' (ECDSA) to the list of known hosts.
ops@localhost's password:
Creating directory '/home/ops'.
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.9.60-linuxkit-aufs x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

ops@ubuntu:~$
```

Auto:

```sh
$ brew install http://git.io/sshpass.rb
$ vault ssh -mode=otp -role=otp_ops -strict-host-key-checking=no ops@localhost -p 10022
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
