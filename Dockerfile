FROM debian:latest

RUN apt-get update && apt-get install -y wget sudo && apt-get clean
ADD install_and_start_perfmon.sh /install_and_start_perfmon.sh
ADD ec2_hack.rb /ec2_hack.rb

ENV CLOUD_HEALTH_SECRET XX_SECRET_XX

CMD ["bash","/install_and_start_perfmon.sh"]