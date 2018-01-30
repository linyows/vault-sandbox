FROM linyows/consul:1.0-agent
MAINTAINER linyows <linyows@gmail.com>

COPY supervisor.d/mysql.ini /etc/supervisor.d/mysql.ini
COPY entry.sh /entry.sh
RUN apk --no-cache add  mysql mysql-client && chmod +x /entry.sh
#COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306
