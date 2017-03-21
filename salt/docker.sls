{% from "salt/map.jinja" import docker with context %}

{% if docker.repo_entry %}
docker-repo-added:
  pkgrepo.managed:
    - humanname: Docker
    - name: {{ docker.repo_entry }}
    - file: {{ docker.repo_file }}
    - keyid: {{ docker.repo_keyid }}
    - keyserver: {{ docker.repo_keyserver }}
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

docker-pip-installed:
  pkg.installed:
    - name: {{ docker.pip }}

docker-compose-installed:
  pip.installed:
    - name: docker-compose
    - require:
      - pkg: docker-installed
      - pkg: docker-pip-installed

docker-running:
  service.running:
    - name: docker
    - enable: True
    - reload: True
    - watch:
      - pkg: docker-installed
