{% from "nginx/map.jinja" import nginx with context %}

nginx-installed:
  pkg.installed:
    - pkgs: {{ nginx.packages }}

nginx-defaulted:
  file.managed:
    - name: {{ nginx.webroot }}/default/index.html
    - source: salt://nginx/default.html.jinja
    - makedirs: True
    - require:
      - pkg: nginx-installed

nginx-dogged:
  file.managed:
    - name: {{ nginx.webroot }}/default/dog.jpg
    - source: salt://nginx/dog.jpg
    - makedirs: True
    - require:
      - pkg: nginx-installed

nginx-configured:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/nginx.conf.jinja
    - template: jinja
    - context:
        hosts: {{ salt['pillar.get']('nginx', {}) }}
        webroot: {{ nginx.webroot }}
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: nginx-installed

nginx-running:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - pkg: nginx-installed
      - file: nginx-configured
