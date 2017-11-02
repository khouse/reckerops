base:

  '*':
    - locale
    - hosts

  'role:master':
    - match: grain
    - docker

  'role:worker':
    - match: grain
    - docker
