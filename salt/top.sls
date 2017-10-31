base:

  '*':
    - locale

  'role:(worker|master)':
    - match: grain_pcr
    - docker
