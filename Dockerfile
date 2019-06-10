FROM		phusion/baseimage
MAINTAINER	Jens Erat <email@jenserat.de>

ENV DEBIAN_FRONTEND noninteractive

# Seafile dependencies and system configuration
RUN set -ex && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl wget socat git python --no-install-recommends && \
    apt-get install -y ffmpeg sqlite3 zlib1g-dev libmemcached-dev libjpeg-dev --no-install-recommends && \
    apt-get install -y python2.7 libpython2.7 python-setuptools python-pip \
            python-imaging python-ldap python-urllib3 python-simplejson \
            python-mysqldb python-memcache --no-install-recommends && \
    pip install --upgrade pip setuptools && \
    rm -f /usr/bin/pip && \
    ln -s /usr/local/bin/pip /usr/bin/pip && \
    pip install pillow moviepy && \
    pip install --upgrade cryptography pyopenssl && \
    apt-get clean && apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /root/.cache/pip

RUN ulimit -n 30000

# Interface the environment
RUN mkdir /opt/seafile
VOLUME /opt/seafile
EXPOSE 10001 12001 8000 8080 8082

# Seafile daemons
RUN mkdir /etc/service/seafile /etc/service/seahub
ADD seafile.sh /etc/service/seafile/run
ADD seahub.sh /etc/service/seahub/run

ADD download-seafile.sh /usr/local/sbin/download-seafile

# Clean up for smaller image
# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Baseimage init process
ENTRYPOINT ["/sbin/my_init"]
