datadog:
  tags: machine:rochester site:tranquilitydesignsmn.com

nginx:
  tranquilitydesigns:
    hostname: tranquilitydesignsmn.com
    upstream: http://127.0.0.1:8080
    redirect_www: true

hosts:
  - tranquilitydesignsmn.com
  - www.tranquilitydesignsmn.com

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
