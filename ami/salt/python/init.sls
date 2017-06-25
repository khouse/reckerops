{% from "python/map.jinja" import python with context %}

python-dependencies-installed:
  pkg.installed:
    - pkgs: {{ python.packages_install }}

python-old-pip-removed:
  pkg.removed:
    - pkgs: {{ python.packages_remove }}
    - require:
      - pkg: python-dependencies-installed

python-new-pip-installed:
  cmd.run:
    - name: easy_install pip
    - require:
      - pkg: python-old-pip-removed
