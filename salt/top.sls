base:

  '*':
    - locale

  'role:master':
    - match: grain
    - docker

  'role:worker':
    - match: grain
    - docker

  'role:proxy':
    - match: grain
    - letsencrypt
    - nginx
