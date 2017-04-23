#!/usr/bin/env bash
echo "key: $CLOUDFLARE_API_KEY" >> /srv/pillar/dns.sls
salt-call --local state.highstate --state-output=mixed
