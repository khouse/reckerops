{% from "user/map.jinja" import user with context %}

user-packages-installed:
  pkg.installed:
    - pkgs: [ sudo, bash ]

user-created:
  user.present:
    - name: {{ user.username }}
    - password: {{ pillar['password'] }}
    - shell: {{ user.shell }}
    - groups: {{ user.groups }}
    - require:
      - pkg: user-packages-installed

{% if 'ssh' in salt['grains.get']('services', []) %}
user-authorized:
  ssh_auth.present:
    - user: {{ user.username }}
    - names: {{ user.pubkeys }}
{% endif %}
