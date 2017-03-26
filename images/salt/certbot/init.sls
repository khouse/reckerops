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
