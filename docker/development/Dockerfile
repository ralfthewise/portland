FROM ubuntu:14.04.1
MAINTAINER Tim Garton <garton.tim@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get -y install curl software-properties-common \
  && curl http://nginx.org/keys/nginx_signing.key | apt-key add - \
  && apt-add-repository 'deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx' \
  && apt-get update \
  && apt-get -y install nginx

ENV RUBY_VERSION 2.1

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | sudo bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install $RUBY_VERSION"

RUN apt-get -y install socat tmux
RUN curl -sSL https://get.docker.com/ubuntu/ | sudo sh
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get -y install nodejs
RUN apt-get -y install python

RUN apt-get -y install redis-server
RUN mkdir /var/run/redis

RUN mkdir -p /home/app && chmod 777 /home/app
ENV HOME /home/app

COPY run.sh /home/app/run.sh
COPY nginx.conf /home/app/nginx.conf

EXPOSE 80

#ENTRYPOINT ["/bin/bash", "-l", "-c", "${0} ${1+\"$@\"}"]
ENTRYPOINT ["/bin/bash", "-l", "/home/app/run.sh"]
#ENTRYPOINT ["/bin/bash", "-l"]
#CMD ["/bin/bash", "-il"]
#CMD ["/home/app/run.sh"]
