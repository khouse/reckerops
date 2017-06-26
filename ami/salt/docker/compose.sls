docker-compose-created:
  file.managed:
    - name: /reckerops/docker/docker-compose.yml
    - makedirs: True
    - contents: "{{ salt['pillar.get']('compose', {}) | yaml }}"
    - user: root
    - group: root
    - mode: 644

docker-compose-configs-copies:
  file.recurse:
    - name: /reckerops/docker/configs
    - source: salt://docker/configs
    - user: root
    - group: root
