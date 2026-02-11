#!/bin/bash
DATE=$(date +%F_%H-%M)
sudo mysqldump lesson9db > /opt/mysql_backup/db_$DATE.sql
rsync -a /opt/mysql_backup/ 192.168.230.129::mysql

