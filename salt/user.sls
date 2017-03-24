{% from "salt/map.jinja" import user with context %}

user-packages-installed:
  pkg.installed:
    - pkgs: [ sudo, bash ]

user-created:
  user.present:
    - name: {{ user.username }}
    - fullname: {{ user.fullname }}
    - empty_password: True
    - shell: {{ user.shell }}
    - groups: {{ user.groups }}
    - require:
      - pkg: user-packages-installed

user-authorized:
  ssh_auth.present:
    - user: {{ user.username }}
    - names: {{ user.ssh }}
    - require:
      - user: user-created