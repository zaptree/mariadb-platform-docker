#!/bin/sh

/usr/bin/maxscale --user=maxscale --config=/etc/mariadb-maxscale-cdc.cnf

sleep 15;

maxctrl --hosts=127.0.0.1:8990 call command cdc add_user avro-router cdcuser cdcpwd

mysql -h 127.0.0.1 -P 6605 -u rpluser --password=rplpwd < /home/mysql2/scripts/mariadb-cdc-init.sql
mysql -h 127.0.0.1 -P 6605 -u rpluser --password=rplpwd < /home/mysql2/scripts/mariadb-cdc-start-slave.sql
