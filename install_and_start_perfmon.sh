#!/usr/bin/env bash

echo "Installing cloud health client"

wget https://s3.amazonaws.com/remote-collector/agent/v14/install_cht_perfmon.sh -O install_cht_perfmon.sh;
sh install_cht_perfmon.sh 14 $CLOUD_HEALTH_SECRET aws;

# modify the ec2 file, restart process
echo "Restarting perfmon with hacked ec2 things"
cp /ec2_hack.rb /opt/cht_perfmon/embedded/lib/ruby/gems/2.1.0/gems/facter-2.4.6/lib/facter/ec2.rb
sudo /etc/init.d/cht_perfmon restart 2>&1 | tee -a /tmp/agent_install_log.txt

echo "Cloud health client installed and running in the background"
# Just block here since the process is executed as a daemon
while true; do sleep 1; done
