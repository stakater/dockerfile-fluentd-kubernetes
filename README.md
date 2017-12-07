# Dockerfile for Fluentd on Kubernetes
Dockerfile for fluentd with 
* fluent-plugin-kubernetes_metadata_filter
* fluent-plugin-elasticsearch
* fluent-plugin-prometheus
* fluent-plugin-concat


Sample config for k8s already in image: 
```
<source>
  type tail
  path /var/log/containers/*.log
  pos_file /var/log/es-containers.log.pos
  time_format %Y-%m-%dT%H:%M:%S.%N
  tag kubernetes.*
  format json
  read_from_head true
  keep_time_key true
</source>

<filter kubernetes.**>
  type kubernetes_metadata
</filter>

<match **>
  @type elasticsearch
  @log_level info
  include_tag_key true
  host elasticsearch
  port 9200
  logstash_format true
  flush_interval 5s
  # Never wait longer than 5 minutes between retries.
  max_retry_wait 60
  # Disable the limit on the number of retries (retry forever).
  disable_retry_limit
  time_key time
  reload_connections false
</match>
```

Volume map `/fluentd/etc/` directory and add `fluent.conf`