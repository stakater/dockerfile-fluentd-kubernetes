#!/bin/bash
set -e

chown -R fluentd /fluentd

fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT &
/fluentd/etc/scripts/kube-gen -watch -type pods -wait 2s:3s -post-cmd '/etc/scripts/kill-processes.sh fluentd' /fluentd/etc/template/${FLUENTD_CONF_TEMPLATE} /fluentd/etc/${FLUENTD_CONF}