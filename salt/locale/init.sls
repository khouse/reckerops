locale-dependencies-installed:
  pkg.installed:
    - name: locales

locale-preferred-installed:
  locale.present:
    - name: en_US.UTF-8
    - require:
      - pkg: locale-dependencies-installed

locale-preferred-defaulted:
  locale.system:
    - name: en_US.UTF-8
    - require:
      - locale: locale-preferred-installed
