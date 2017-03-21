{% from "salt/map.jinja" import certbot with context %}

{% if certbot.ppa or certbot.repo_entry %}
certbot-repo-added:
  pkgrepo.managed:
    {% if certbot.ppa %}
    - ppa: {{ certbot.ppa }}
    {% elif certbot.repo_entry %}
    - name: {{ certbot.repo_entry }}
    - file: {{ certbot.repo_file }}
    {% endif %}
    - require_in:
      - pkg: certbot-installed
{% endif %}

certbot-installed:
  pkg.installed:
    - name: certbot
    {% if certbot.repo_entry %}
    - fromrepo: jessie-backports
    {% endif %}
