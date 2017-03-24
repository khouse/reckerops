{% from "salt/map.jinja" import python with context %}

python-deps-installed:
  pkg.installed:
    - pkgs: {{ python.pkgs_install }}

python-old-pip-removed:
  pkg.removed:
    - pkgs: {{ python.pkgs_remove }}
    - require:
      - pkg: python-deps-installed

python-new-pip-installed:
  cmd.run:
    - name: easy_install pip
    - unless: grep "{{ python.pip_version }}" <(pip --version) && pip install --upgrade pip

python-packages-installed:
  cmd.run:
    - name: sudo -H pip install --upgrade {{ python.pip_packages|join(' ') }}
