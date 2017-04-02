host-names-added:
  host.present:
    - ip: 127.0.0.1
    - names: {{ salt['pillar.get']('hosts', []) }}
