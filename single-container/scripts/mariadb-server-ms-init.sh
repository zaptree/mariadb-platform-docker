export PATH=/usr/local/mysql/bin:$PATH

sudo -u mysql2 /usr/local/mysql/scripts/mysql_install_db --datadir=/var/lib/mysql/1/ --basedir=/usr/local/mysql
sudo -u mysql2 /usr/local/mysql/scripts/mysql_install_db --datadir=/var/lib/mysql/2/ --basedir=/usr/local/mysql
sudo -u mysql2 /usr/local/mysql/scripts/mysql_install_db --datadir=/var/lib/mysql/3/ --basedir=/usr/local/mysql

/usr/local/mysql/bin/mysqld --defaults-file=/etc/mariadb-server-1.cnf &
/usr/local/mysql/bin/mysqld --defaults-file=/etc/mariadb-server-2.cnf &
/usr/local/mysql/bin/mysqld --defaults-file=/etc/mariadb-server-3.cnf &

sleep 45

/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33061 < /home/mysql2/scripts/mariadb-server-ms-init.sql
/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33062 < /home/mysql2/scripts/mariadb-server-ms-init.sql
/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33063 < /home/mysql2/scripts/mariadb-server-ms-init.sql

sleep 45

/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33061 < /home/mysql2/scripts/mariadb-server-ms-seed.sql

sleep 45

if [ -f /var/run/mysqld/mysqld1.pid ]; then
  kill `cat /var/run/mysqld/mysqld1.pid`
fi
if [ -f /var/run/mysqld/mysqld2.pid ]; then
  kill `cat /var/run/mysqld/mysqld2.pid`
fi
if [ -f /var/run/mysqld/mysqld3.pid ]; then
  kill `cat /var/run/mysqld/mysqld3.pid`
fi
