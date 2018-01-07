FROM centos:latest
RUN yum update
RUN yum install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm -y
RUN yum install percona-xtrabackup-24 wget cronie qpress openssh-clients -y
RUN wget https://storage.googleapis.com/pub/gsutil.tar.gz  && tar xfz gsutil.tar.gz -C $HOME && rm gsutil.tar.gz
VOLUME /var/backups/
VOLUME /var/lib/mysql
COPY .boto /root/.boto
RUN echo "Ranger Started" >> /var/log/cron
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN chmod 0644 /etc/crontab
COPY mysql-backup.sh /etc/ranger-scripts/mysql-backup.sh
RUN chmod +x /etc/ranger-scripts/mysql-backup.sh
RUN echo "30 2 */2 * * root /etc/ranger-scripts/mysql-backup.sh &>> /var/log/cron" >> /etc/crontab

ENTRYPOINT ["/bin/bash", "-c", "crond && tail -f /var/log/cron"]
#ENTRYPOINT ["/bin/bash", "-c", "/etc/ranger-scripts/mysql-backup.sh && tail -f /var/log/cron"]

## registry clean up
##https://ahmet.im/blog/google-container-registry-tips/#gcr-tip-8
