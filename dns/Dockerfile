FROM debian:jessie
MAINTAINER Alex Recker

ADD https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub /tmp/salt.pub
ADD saltstack.list /etc/apt/sources.list.d/
RUN apt-key add /tmp/salt.pub
RUN apt-get update && apt-get install -y salt-minion ruby

ADD https://raw.githubusercontent.com/cloudflare/salt-cloudflare/master/cloudflare.py /srv/salt/_states/cloudflare.py

ADD zones.yml /zones.yml
ADD state.sls /srv/salt/dns.sls
ADD entry.rb /entry.rb

ENTRYPOINT ["ruby", "/entry.rb"]
