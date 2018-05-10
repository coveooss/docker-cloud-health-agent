FROM debian:latest

# In order to build the Docker image, we have to run the installer
# in an environment where it can connect to CloudHealth and
# initialize itself one time.
ARG CLOUD_HEALTH_SECRET=XX_SECRET_XX
ARG CLOUD_HEALTH_VERSION=19
ARG CLOUD=aws

RUN apt-get update && \
    apt-get install -y curl procps wget sudo sed && \
    apt-get clean

ADD ec2_hack.rb /ec2_hack.rb
ADD install_perfmon.sh /install_perfmon.sh
RUN bash -x /install_perfmon.sh $CLOUD_HEALTH_SECRET $CLOUD_HEALTH_VERSION $CLOUD
RUN rm /install_perfmon.sh

ADD start_perfmon.sh /start_perfmon_temp.sh
RUN cat /start_perfmon_temp.sh | sed "s/__CLOUD_HEALTH_VERSION__/$CLOUD_HEALTH_VERSION/g" > /start_perfmon.sh
RUN rm /start_perfmon_temp.sh

# Blow away the config; the entrypoint creates a new one before starting cht_perfmon
RUN sudo /etc/init.d/cht_perfmon stop
RUN mv /ec2_hack.rb $(find /opt/cht_perfmon/embedded -name ec2.rb | grep lib/facter/ec2.rb)
RUN find /opt/cht_perfmon/embedded -name saved_state.json | xargs rm -f
RUN rm -f /opt/cht_perfmon/cht_perfmon_collector.output \
          /opt/cht_perfmon/saved_state.json \
          /opt/cht_perfmon/monitor.pid \
          /opt/cht_perfmon/collector.pid

ENV CLOUD_HEALTH_SECRET XX_SECRET_XX
ENV CLOUD               $CLOUD

CMD ["bash", "-x", "/start_perfmon.sh"]
