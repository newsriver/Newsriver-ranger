#!/bin/bash
BOTO_CONFIG=/root/.boto
mkdir /var/backups/mysql
xtrabackup --backup --datadir=/var/lib/mysql --user=root --password='$Revenge_Fringe' --host=176.9.82.217 --port=3336 --parallel=2 --compress --compress-threads=2 --stream=xbstream 1> /var/backups/mysql/backup-$(date +%d-%m-%Y).xbstream 2>> /var/log/cron &&
/root/gsutil/gsutil mv -n /var/backups/mysql/backup-$(date +%d-%m-%Y).xbstream gs://backup-newsriver/ &>> /var/log/cron
rm -R /var/backups/mysql
