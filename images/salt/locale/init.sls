{% from "locale/map.jinja" import locale with context %}

locale-packages-installed:
  pkg.installed:
    - pkgs: {{ locale.packages }}

locale-preferred-installed:
  locale.present:
    - name: {{ locale.preferred }}

locale-preferred-defaulted:
  locale.system:
    - name: {{ locale.preferred }}
    - require:
      - locale: locale-preferred-installed