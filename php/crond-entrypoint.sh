#!/bin/bash

set -e

env >> /etc/default/locale

/etc/init.d/cron start

exec "$@"
