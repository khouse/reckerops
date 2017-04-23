{% from "nginx/map.jinja" import nginx with context %}

bootstrap-script-created:
  file.managed:
    - name: /reckerops/bootstrap.sh
    - source: salt://bootstrap/bootstrap.sh.jinja
    - template: jinja
    - context:
        email: {{ salt['pillar.get']('email') }}
        webroot: {{ nginx.webroot }}
        ip: {{ salt['pillar.get']('ip') }}
        hosts: {{ salt['pillar.get']('nginx', {}) }}
    - makedirs: True
    - user: root
    - group: root
    - mode: 744
