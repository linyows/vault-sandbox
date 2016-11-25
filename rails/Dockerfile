FROM alpine:latest
MAINTAINER linyows <linyows@gmail.com>

ENV PYTHON_VERSION 2.7.12-r0
ENV PY_PIP_VERSION 8.1.2-r0
ENV SUPERVISOR_VERSION 3.3.1

RUN apk --no-cache add python=$PYTHON_VERSION py-pip=$PY_PIP_VERSION && \
    pip install --upgrade pip && \
    pip install supervisor==$SUPERVISOR_VERSION

RUN apk --no-cache add curl-dev ruby-dev build-base git cmake \
                       ruby ruby-io-console ruby-json yaml mysql-client \
                       zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev mysql-dev libffi-dev libc-dev && \
    gem install -N bundler

RUN gem install -N nokogiri -- --use-system-libraries && \
    echo 'gem: --no-document' >> ~/.gemrc && \
    install -m644 ~/.gemrc /etc/gemrc && \
    bundle config --global build.nokogiri  "--use-system-libraries" && \
    bundle config --global build.nokogumbo "--use-system-libraries"

WORKDIR /app
VOLUME "/app"
ADD supervisord.conf /supervisord.conf

EXPOSE 3000
CMD ["supervisord", "--nodaemon", "--configuration", "/supervisord.conf"]
