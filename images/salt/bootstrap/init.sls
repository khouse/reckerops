bootstrap-script-created:
  file.managed:
    - name: /reckerops/bootstrap.sh
    - source: salt://bootstrap/bootstrap.sh
    - template: jinja
    - context:
        hosts: {{ salt['pillar.get']('nginx', {}) }}
    - makedirs: True
    - user: root
    - group: root
    - mode: 744
