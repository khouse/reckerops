{% from "certbot/map.jinja" import certbot with context %}

certbot-repo-added:
  pkgrepo.managed:
    - name: {{ certbot.repo.entry }}
    - file: {{ certbot.repo.file }}
    - require_in:
      - pkg: certbot-installed

certbot-installed:
  pkg.installed:
    - name: certbot
    - fromrepo: jessie-backports

certbot-renew-script-created:
  file.managed:
    - name: /reckerops/certbot-renew.sh
    - source: salt://certbot/renew.sh
    - makedirs: True
    - user: root
    - group: root
    - mode: 744

certbot-renew-cron-installed:
  cron.present:
    - name: /reckerops/certbot-renew.sh
    - user: root
    - minute: 0
    - hour: 1
    - dayweek: SUN
