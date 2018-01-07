FROM centos:latest
RUN yum update
RUN yum install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm -y
RUN yum install percona-xtrabackup-24 wget cronie qpress openssh-clients -y
RUN wget https://storage.googleapis.com/pub/gsutil.tar.gz  && tar xfz gsutil.tar.gz -C $HOME && rm gsutil.tar.gz
VOLUME /var/backups/
VOLUME /var/lib/mysql
VOLUME /var/ranger-scripts/
COPY .boto /root/.boto
RUN echo "Ranger Started" >> /var/log/cron
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN chmod 0644 /etc/crontab
COPY mysql-backup.sh /etc/ranger-scripts/mysql-backup.sh
RUN chmod +x /etc/ranger-scripts/mysql-backup.sh
RUN yum install openssl-libs -y
RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
RUN yum install https://packages.elastic.co/curator/5/centos/7/Packages/elasticsearch-curator-5.4.1-1.x86_64.rpm -y
ENV LANG en_US.utf8
COPY curator_clean_actions.yml /var/ranger-scripts/curator_clean_actions.yml
COPY curator_snapshot_actions.yml /var/ranger-scripts/curator_snapshot_actions.yml
COPY curator_config.yml /etc/curator_config.yml
COPY clean-elastic.sh /etc/ranger-scripts/clean-elastic.sh
RUN chmod +x /etc/ranger-scripts/clean-elastic.sh
COPY snapshot-elastic.sh /etc/ranger-scripts/snapshot-elastic.sh
RUN chmod +x /etc/ranger-scripts/snapshot-elastic.sh

RUN echo "30 1 * * * root /etc/ranger-scripts/clean-elastic.sh &>> /var/log/cron" >> /etc/crontab
RUN echo "30 2 */2 * * root /etc/ranger-scripts/mysql-backup.sh &>> /var/log/cron" >> /etc/crontab
RUN echo "30 3 * * 7 root /etc/ranger-scripts/snapshot-elastic.sh &>> /var/log/cron" >> /etc/crontab

ENTRYPOINT ["/bin/bash", "-c", "crond && tail -f /var/log/cron"]


#EXAMPLES AND TEST COMANDS
#ENTRYPOINT ["/etc/ranger-scripts/clean-elastic.sh"]
#ENTRYPOINT ["/bin/bash", "-c", "/etc/ranger-scripts/mysql-backup.sh && tail -f /var/log/cron"]
## registry clean up
##https://ahmet.im/blog/google-container-registry-tips/#gcr-tip-8
