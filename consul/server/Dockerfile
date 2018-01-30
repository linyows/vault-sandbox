FROM linyows/consul:1.0
MAINTAINER linyows <linyows@gmail.com>

RUN apk --no-cache add supervisor

COPY consul.d /etc/consul.d
COPY supervisor.d /etc/supervisor.d
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 8300 53 53/udp

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
