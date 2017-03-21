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
    - name: pip install --upgrade {{ python.pip_packages|join(' ') }}

    # TODO: Make centos do this mess instead
    # user@webserver:~$ wget https://dl.eff.org/certbot-auto
    # user@webserver:~$ chmod a+x ./certbot-auto
    # user@webserver:~$ ./certbot-auto --help
    # user@server:~$ wget -N https://dl.eff.org/certbot-auto.asc
    # user@server:~$ gpg2 --recv-key A2CFB51FA275A7286234E7B24D17C995CD9775F2
    # user@server:~$ gpg2 --trusted-key 4D17C995CD9775F2 --verify certbot-auto.asc certbot-auto
