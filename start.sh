#!/bin/bash
set -e

# Convert COMMAND variable into an array
# Simulating positional parameter behaviour
IFS=' ' read -r -a CMD_ARRAY <<< "$COMMAND"

# explicitly setting positional parameters ($@) to CMD_ARRAY
set -- "${CMD_ARRAY[@]}"
# From this point, positional parameters ($@)will be set to the parameters in the COMMAND variable.

# chown home and data folder
chown -R fluentd /fluentd

# https://github.com/fluent/fluentd-docker-image/issues/48
# Running fluentd as Root so that it can read logs from /var/log without permission issues.
exec "$@"