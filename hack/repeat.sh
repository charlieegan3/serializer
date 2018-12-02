#!/usr/bin/env bash

set -ex

: ${INTERVAL?"INTERVAL in seconds must be set, e.g. 3600"}
: ${COMMAND?"COMMAND to be executed on schedule, e.g. rake save_graph"}

while [ 1 ]; do
  eval $COMMAND

  echo "Sleeping for $INTERVAL seconds..." && sleep $INTERVAL
done
