{% from "firewall/map.jinja" import firewall with context %}

firewall-package-installed:
  pkg.installed:
    - name: iptables

firewall-ingress-deny:
  iptables.set_policy:
    - chain: INPUT
    - policy: DROP
    - require:
      - pkg: firewall-package-installed

firewall-egress-allow:
  iptables.set_policy:
    - chain: OUTPUT
    - policy: ACCEPT
    - require:
      - pkg: firewall-package-installed

firewall-allow-established:
  iptables.append:
    - chain: INPUT
    - connstate: ESTABLISHED,RELATED
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-local:
  iptables.append:
    - chain: INPUT
    - source: 127.0.0.1
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-docker:
  iptables.append:
    - chain: INPUT
    - source: {{ firewall.docker_range }}
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-ssh:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: {{ firewall.ssh_port }}
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-http:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: {{ firewall.http_port }}
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-https:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: {{ firewall.https_port }}
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow
