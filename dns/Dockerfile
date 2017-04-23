FROM debian:jessie
MAINTAINER Alex Recker
ADD https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub /tmp/salt.pub
ADD saltstack.list /etc/apt/sources.list.d/
RUN apt-key add /tmp/salt.pub
RUN apt-get update && apt-get install -y salt-minion
ADD cloudflare.py /srv/salt/_states/cloudflare.py
ADD /salt /srv/salt
ADD /pillar /srv/pillar
ADD entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
