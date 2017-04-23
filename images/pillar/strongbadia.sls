ip: 127.0.0.1

datadog:
  tags: 'machine:strongbadia website:test.alexrecker.com'

nginx:
  test:
    hostname: test.alexrecker.com
    upstream: http://127.0.0.1:8080

hosts:
  - test.alexrecker.com

compose:
  version: '2'
  services:
   db:
     image: mysql
     volumes:
       - db:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: wordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress
   wp:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - 8080:80
     restart: always
     links:
       - db:mysql
     environment:
       WORDPRESS_DB_PASSWORD: wordpress

  volumes:
    db:
