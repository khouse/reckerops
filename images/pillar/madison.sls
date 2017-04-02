hosts:
  reckerdogs.com:
    upstream: http://127.0.0.1:8002

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

   reckerdogs:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - 8002:80
     restart: always
     links:
       - db:mysql
     environment:
       WORDPRESS_TABLE_PREFIX: dog
       WORDPRESS_DB_PASSWORD: wordpress

  volumes:
    db:
