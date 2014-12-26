FROM ubuntu:14.04.1
MAINTAINER radar <radar@radartools.net>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get -y install curl software-properties-common \
  && curl http://nginx.org/keys/nginx_signing.key | apt-key add - \
  && apt-add-repository 'deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx' \
  && apt-get update \
  && apt-get -y install nginx

ENV RUBY_VERSION 2.1

RUN apt-get -y update
RUN apt-get -y install curl sudo software-properties-common apt-transport-https ca-certificates
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN apt-add-repository 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
RUN apt-get -y update
RUN apt-get -y install nginx-extras passenger
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | sudo bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install $RUBY_VERSION"
RUN apt-get -y install socat

ADD ./run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
CMD ["run.sh"]
