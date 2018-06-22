FROM stakater/fluentd:1.2.0

ENV ELASTICSEARCH_HOST es-logging.default.svc
ENV FLUENTD_CONF_TEMPLATE=fluent.conf.tpl

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev wget gnupg && \
    gem install --no-document fluent-plugin-kubernetes_metadata_filter -v 0.26.2 && \
    gem install --no-document fluent-plugin-elasticsearch -v 1.9.5 && \
    gem install --no-document fluent-plugin-prometheus -v 0.2.1 && \
    gem install --no-document fluent-plugin-concat -v 2.1.0 && \
    gem install --no-document fluent-plugin-rewrite-tag-filter -v 2.1.0 && \
    gem install --no-document fluent-plugin-slack -v 0.6.7 && \
    gem cleanup fluentd && \
    apk del .build-deps && \
    cd /tmp && \
    wget https://github.com/stakater/kube-gen/releases/download/0.3.4/kube-gen && \
    mkdir -p /kubegen/ && \
    mv /tmp/kube-gen /kubegen/kube-gen && \
    chmod +x /kubegen/kube-gen && \
    rm -rf /tmp/*

# Remove default conf
RUN rm -f /fluentd/etc/*.conf

COPY ./${FLUENTD_CONF_TEMPLATE} /fluentd/etc/template/
COPY ./kill-processes.sh /fluentd/etc/scripts/

# Replace fluentd executable to run fluentd as root
# https://github.com/fluent/fluentd-docker-image/issues/48
RUN rm -rf /etc/service/fluentd/*
ADD fluentd.sh /etc/service/fluentd/run

ADD kubegen.sh /etc/service/kubegen/run
