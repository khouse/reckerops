{% from "salt/map.jinja" import docker with context %}

{% if docker.repo %}
docker-repo-added:
  pkgrepo.managed:
    - humanname: Docker
    - name: {{ docker.repo_entry }}
    - file: {{ docker.repo.file }}
    - keyid: {{ docker.repo.keyid }}
    - keyserver: {{ docker.repo.keyserver }}
    - require_in:
      - pkg: docker-installed
{% endif %}

docker-installed:
  pkg.installed:
    - name: {{ docker.package }}

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
