#!/usr/bin/env bash

set -x
set -e

/opt/cht_perfmon/embedded/bin/cht_perfmon_installer.rb $CLOUD_HEALTH_SECRET /etc/chtcollectd $CLOUD deb production __CLOUD_HEALTH_VERSION__

/etc/init.d/cht_perfmon run
