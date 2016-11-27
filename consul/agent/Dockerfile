FROM linyows/consul:0.7
MAINTAINER linyows <linyows@gmail.com>

RUN apk --no-cache add supervisor

COPY consul.d /etc/consul.d
COPY supervisor.d /etc/supervisor.d
COPY supervisord.conf /etc/supervisord.conf

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
