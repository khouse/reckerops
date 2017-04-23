FROM debian:jessie
MAINTAINER Alex Recker
ADD https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub /tmp/salt.pub
ADD saltstack.list /etc/apt/sources.list.d/
RUN apt-key add /tmp/salt.pub
RUN apt-get update && apt-get install -y salt-minion
ADD https://raw.githubusercontent.com/cloudflare/salt-cloudflare/4960efce3a6ca62a4abad12d01b3960259773497/cloudflare.py /srv/salt/_states/cloudflare.py
ADD entry.sh /entry.sh
ADD salt /srv/salt
ADD pillar /srv/pillar
ENTRYPOINT ["/entry.sh"]
