export PATH=/usr/local/mysql/bin:$PATH

sudo -u mysql2 /usr/local/mysql/scripts/mysql_install_db --datadir=/var/lib/mysql/1/ --basedir=/usr/local/mysql
sudo -u mysql2 /usr/local/mysql/scripts/mysql_install_db --datadir=/var/lib/mysql/2/ --basedir=/usr/local/mysql
sudo -u mysql2 /usr/local/mysql/scripts/mysql_install_db --datadir=/var/lib/mysql/3/ --basedir=/usr/local/mysql

sudo -u mysql2 /usr/local/mysql/bin/mysqld_multi start 1
sudo -u mysql2 /usr/local/mysql/bin/mysqld_multi start 2
sudo -u mysql2 /usr/local/mysql/bin/mysqld_multi start 3

sleep 45

/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33061 < /home/mysql2/scripts/mariadb-server-ms-init.sql
/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33062 < /home/mysql2/scripts/mariadb-server-ms-init.sql
/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33063 < /home/mysql2/scripts/mariadb-server-ms-init.sql

sleep 45

/usr/local/mysql/bin/mysql -h 127.0.0.1 -P 33061 < /home/mysql2/scripts/mariadb-server-ms-seed.sql

sudo -u mysql2 /usr/local/mysql/bin/mysqld_multi stop 3
sudo -u mysql2 /usr/local/mysql/bin/mysqld_multi stop 2
sudo -u mysql2 /usr/local/mysql/bin/mysqld_multi stop 1
