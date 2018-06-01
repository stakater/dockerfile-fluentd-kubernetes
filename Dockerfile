FROM stakater/fluentd:1.2.0

ENV ELASTICSEARCH_HOST es-logging.default.svc

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev wget gnupg && \
    gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 0.26.2 && \
    gem install --no-document fluent-plugin-elasticsearch -v 1.9.5 && \
    gem install --no-document fluent-plugin-prometheus -v 0.2.1 && \
    gem install --no-document fluent-plugin-concat -v 2.1.0 && \
    gem cleanup fluentd && \
    apk del .build-deps

# Remove default conf
RUN rm -f /fluentd/etc/*.conf

COPY ./fluent.conf /fluentd/etc/

# Replace fluentd executable to run fluentd as root
# https://github.com/fluent/fluentd-docker-image/issues/48
RUN rm -rf /etc/service/fluentd/*
ADD start.sh /etc/service/fluentd/run