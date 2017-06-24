{% from "user/map.jinja" import user with context %}
{% set terrible_password='$1$QN1zC2.p$oqj2NhZN3oncmfHnfNzkQ.' %}

user-packages-installed:
  pkg.installed:
    - pkgs: [ sudo, bash ]

user-created:
  user.present:
    - name: {{ user.username }}
    - password: {{ pillar.get('password', terrible_password) }}
    - shell: {{ user.shell }}
    - groups: {{ user.groups }}
    - require:
      - pkg: user-packages-installed

user-authorized:
  ssh_auth.present:
    - user: {{ user.username }}
    - names: {{ user.pubkeys }}
