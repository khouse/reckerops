datadog:
  tag: rochester

hosts:
  tranquilitydesignsmn.com:
    upstream: http://127.0.0.1:8080

compose:
  version: '2'
  services:
   db:
     image: postgres
     volumes:
       - db:/var/lib/postgresql/data
     restart: always
     environment:
       POSTGRES_PASSWORD: mysecretpassword

  volumes:
    db:
