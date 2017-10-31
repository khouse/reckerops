nginx-package-installed:
  pkg.installed:
    - name: nginx

nginx-running:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - pkg: nginx-package-installed
