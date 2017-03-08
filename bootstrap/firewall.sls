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
    - source: 172.17.0.0/16
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-ssh:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 22
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-http:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 80
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow

firewall-allow-https:
  iptables.append:
    - chain: INPUT
    - proto: TCP
    - dport: 443
    - jump: ACCEPT
    - require:
      - iptables: firewall-ingress-deny
      - iptables: firewall-egress-allow
