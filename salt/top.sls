base:

  '*':
    - locale

  'role:(worker|master)':
    - match: grain_pcr
    - docker

  'role:proxy':
    - match: grain
    - letsencrypt
    - nginx
