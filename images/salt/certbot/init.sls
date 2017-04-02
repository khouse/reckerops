{% from "certbot/map.jinja" import certbot with context %}

{% if certbot.ppa or certbot.repo %}
certbot-repo-added:
  pkgrepo.managed:
    {% if certbot.ppa %}
    - ppa: {{ certbot.ppa }}
    {% elif certbot.repo %}
    - name: {{ certbot.repo.entry }}
    - file: {{ certbot.repo.file }}
    {% endif %}
    - require_in:
      - pkg: certbot-installed
{% endif %}

certbot-installed:
  pkg.installed:
    - name: certbot
    {% if certbot.repo %}
    - fromrepo: jessie-backports
    {% endif %}

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
