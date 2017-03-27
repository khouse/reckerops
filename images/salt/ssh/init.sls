{% from "ssh/map.jinja" import ssh with context %}

ssh-installed:
  pkg.installed:
    - name: {{ ssh.package }}

ssh-configured:
  file.managed:
    - name: {{ ssh.config }}
    - source: salt://ssh/sshd_config.jinja
    - template: jinja
    - context:
        port: {{ ssh.port }}
        root_login: {{ ssh.root_login }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssh-installed

ssh-running:
  service.running:
    - name: {{ ssh.service }}
    - enable: True
    - watch:
      - pkg: ssh-installed
      - file: ssh-configured
