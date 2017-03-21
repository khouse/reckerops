{% from "salt/map.jinja" import locale with context %}

locale-preferred-installed:
  locale.present:
    - name: {{ locale.preferred }}

locale-preferred-defaulted:
  locale.system:
    - name: {{ locale.preferred }}
    - require:
      - locale: locale-preferred-installed
