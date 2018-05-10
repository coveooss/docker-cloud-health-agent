#!/usr/bin/env bash

set -x
set -e

export CLOUD_HEALTH_SECRET=$1
export CLOUD_HEALTH_VERSION=$2
export CLOUD=$3

echo "Installing cloud health client"

curl -O -L https://s3.amazonaws.com/remote-collector/agent/v${CLOUD_HEALTH_VERSION}/install_cht_perfmon.sh
bash -x install_cht_perfmon.sh $CLOUD_HEALTH_VERSION $CLOUD_HEALTH_SECRET $CLOUD

sudo /etc/init.d/cht_perfmon stop

# modify the ec2 file, restart process
# cp /ec2_hack.rb $(find /opt/cht_perfmon -name ec2.rb | grep lib/facter/ec2.rb)
