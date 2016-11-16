FROM linyows/consul:0.6
MAINTAINER linyows <linyows@gmail.com>

ENV DNS_RESOLVES consul
ENV DNS_PORT 8600

ADD ./config /config/
ENTRYPOINT ["/bin/consul", "agent", "-server", "-config-dir=/config"]
