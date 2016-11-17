Docker Vault
============

vault testing

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
```

mysql
-----

```sh
docker run -d --name mysql --hostname mysql \
    -p 13306:3306 \
    -e MYSQL_ROOT_PASSWORD=secret \
    library/mysql:5.7
```
