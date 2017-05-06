FROM ubuntu:16.10
MAINTAINER joleuger <johannes.leupolz@gmail.com>

ADD ./files/ /tmp/

RUN chmod +x /tmp/install/install.sh && sleep 1 && /tmp/install/install.sh && rm -rf /tmp/*

#VOLUME ["/settings","/sys/fs/cgroup"]
VOLUME ["/settings"]

EXPOSE 22 8000

ENV container docker

STOPSIGNAL SIGRTMIN+3

# TODO: Switch to supervisord
# Run systemd using Workaround for docker/docker#27202, technique based on comments from docker/docker#9212
# CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
CMD ["/bin/bash"]
