{% from "salt/map.jinja" import user with context %}
{% from "salt/map.jinja" import nginx with context %}
{% set domains = salt['pillar.get']('hosts', {}).keys() %}
bootstrap-script-generated:
  file.managed:
    - name: /usr/local/bin/reckerops-bootstrap
    - source: salt://salt/files/bootstrap.jinja
    - user: root
    - mode: 700
    - template: jinja
    - context:
        domains: {{ domains }}
        email: {{ user.email }}
        webroot: {{ nginx.webroot }}
