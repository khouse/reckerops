datadog-apt-https:
  pkg.installed:
    - name: apt-transport-https

datadog-repo:
  pkgrepo.managed:
    - humanname: "Datadog"
    - name: deb https://apt.datadoghq.com/ stable main
    - keyserver: keyserver.ubuntu.com
    - keyid: C7A7DA52
    - file: /etc/apt/sources.list.d/datadog.list
    - require:
      - pkg: datadog-apt-https

datadog-pkg:
  pkg.latest:
    - name: datadog-agent
    - refresh: True
    - require:
      - pkgrepo: datadog-repo

datadog-conf:
  file.managed:
    - name: /etc/dd-agent/datadog.conf
    - source: salt://datadog/datadog.conf.jinja
    - template: jinja
    - context:
        API_KEY: {{ pillar['datadog']['key'] }}
        TAG: {{ pillar['datadog']['tags'] }}
    - watch:
      - pkg: datadog-pkg

datadog-agent-service:
  service.running:
    - name: datadog-agent
    - enable: True
    - watch:
      - pkg: datadog-agent
      - file: datadog-conf
