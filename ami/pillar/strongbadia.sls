hosts:
  - reckerdogs.com
  - www.reckerdogs.com

nginx:
  reckerdogs:
    hostname: reckerdogs.com
    redirect_www: True
    upstream: http://127.0.0.1:8000

compose:
  version: '2'
  services:
    db:
      image: mysql
      restart: always
      network_mode: bridge
      mem_limit: 50m
      volumes:
        - db:/var/lib/mysql
        - ./configs/mysql/my.cnf:/etc/mysql/my.cnf
      env_file:
        - ./docker.env
    wp:
      depends_on: [ db ]
      image: wordpress:latest
      restart: always
      network_mode: bridge
      ports:
        - 8000:80
      links:
        - db:mysql
      volumes:
        - www:/var/www/html
        - ./configs/php/uploads.ini:/usr/local/etc/php/conf.d/uploads.ini
      env_file:
        - ./docker.env
  volumes:
    db: {}
    www: {}
