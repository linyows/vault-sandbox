FROM linyows/consul:0.6
MAINTAINER linyows <linyows@gmail.com>

ENV DNS_RESOLVES consul
ENV DNS_PORT 53

ADD ./config /config/
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53 53/udp
ENTRYPOINT ["/bin/consul", "agent", "-server", "-config-dir=/config"]
