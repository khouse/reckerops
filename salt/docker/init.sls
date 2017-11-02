docker-dependencies-installed:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - software-properties-common
    - require_in:
      - pkgrepo: docker-repo-added

docker-repo-added:
  pkgrepo.managed:
    - name: deb [arch=amd64] https://download.docker.com/linux/debian stretch stable
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/debian/gpg
    - require_in:
      - pkg: docker-package-installed

docker-package-installed:
  pkg.installed:
    - name: docker-ce

docker-service-running:
  service.running:
    - name: docker
    - watch:
      - pkg: docker-package-installed
