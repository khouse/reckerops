FROM debian:latest
MAINTAINER Alex Recker <alex@reckerfamily.com>
RUN apt-get update && apt-get install -y python-pip cron
RUN pip install awscli
RUN mkdir -p /data
ADD cron /etc/cron.d/backup-cron
ADD backup.sh /
RUN crontab /etc/cron.d/backup-cron
CMD ["cron", "-f"]
