docker-compose-config-created:
  file.managed:
    - name: /d/docker-compose.yml
    - makedirs: True
    - contents: "{{ salt['pillar.get']('compose') | yaml }}"
    - user: root
    - group: root
    - mode: 644
