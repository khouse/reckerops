{% from "docker/map.jinja" import docker with context %}

{% if docker.repo %}
docker-repo-added:
  pkgrepo.managed:
    - humanname: Docker
    - name: {{ docker.repo.entry }}
    - file: {{ docker.repo.file }}
    - keyid: {{ docker.repo.keyid }}
    - keyserver: {{ docker.repo.keyserver }}
    - require_in:
      - pkg: docker-installed
{% endif %}

docker-installed:
  pkg.installed:
    - name: {{ docker.package }}

docker-compose-installed:
  file.managed:
    - name: /usr/local/bin/docker-compose
    - source: https://github.com/docker/compose/releases/download/1.14.0/docker-compose-Linux-x86_64
    - user: root
    - group: root
    - mode: 755

docker-group-created:
  group.present:
    - name: docker
    - system: True
    - require:
      - pkg: docker-installed

docker-running:
  service.running:
    - name: docker
    - enable: True
    - reload: True
    - watch:
      - pkg: docker-installed
