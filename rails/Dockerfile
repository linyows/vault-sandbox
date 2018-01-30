FROM linyows/consul:1.0-agent
MAINTAINER linyows <linyows@gmail.com>

RUN apk --no-cache add curl-dev ruby-dev build-base git cmake \
                       ruby ruby-io-console ruby-json yaml mysql-client \
                       zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev mysql-dev libffi-dev libc-dev && \
    gem install -N bundler

RUN gem install -N nokogiri -- --use-system-libraries && \
    echo 'gem: --no-document' >> ~/.gemrc && \
    install -m644 ~/.gemrc /etc/gemrc && \
    bundle config --global build.nokogiri  "--use-system-libraries" && \
    bundle config --global build.nokogumbo "--use-system-libraries"

VOLUME "/app"
COPY supervisor.d/rails.ini /etc/supervisor.d/rails.ini

EXPOSE 3000
