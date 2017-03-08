{% from "docker/map.jinja" import docker with context %}

docker-repo-added:
  pkgrepo.managed:
    - humanname: Docker
    - name: {{ docker.repo_entry }}
    - file: {{ docker.repo_file }}
    - keyid: {{ docker.repo_keyid }}
    - keyserver: {{ docker.repo_keyserver }}


docker-installed:
  pkg.installed:
    - name: docker-engine
    - require:
      - pkgrepo: docker-repo-added
