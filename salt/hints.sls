{% from "salt/map.jinja" import user with context %}
{% from "salt/map.jinja" import nginx with context %}
{% set domains = salt['pillar.get']('hosts', {}).keys() %}

hint-placed:
  file.managed:
    - name: /home/{{ user.username }}/hello.sh
    - source: salt://salt/files/certs.sh.jinja
    - user: {{ user.username }}
    - template: jinja
    - context:
        domains: {{ domains }}
        email: {{ user.email }}
        webroot: {{ nginx.webroot }}
