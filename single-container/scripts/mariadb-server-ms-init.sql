flush privileges;

create user 'maxuser'@'%' identified by 'maxpwd';
grant SELECT on mysql.user to 'maxuser'@'%';
GRANT SELECT ON mysql.db TO 'maxuser'@'%';
GRANT SELECT ON mysql.tables_priv TO 'maxuser'@'%';
GRANT SUPER ON *.* TO 'maxuser'@'%';
grant RELOAD on *.* to 'maxuser'@'%';
GRANT SHOW DATABASES ON *.* TO 'maxuser'@'%';
GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON *.* TO 'maxuser'@'%';
GRANT REPLICATION CLIENT on *.* to 'maxuser'@'%';
GRANT REPLICATION SLAVE ON *.* TO 'maxuser'@'%';

create user 'maxuser'@'localhost' identified by 'maxpwd';
grant SELECT on mysql.user to 'maxuser'@'localhost';
GRANT SELECT ON mysql.db TO 'maxuser'@'localhost';
GRANT SELECT ON mysql.tables_priv TO 'maxuser'@'localhost';
GRANT SUPER ON *.* TO 'maxuser'@'localhost';
grant RELOAD on *.* to 'maxuser'@'localhost';
GRANT SHOW DATABASES ON *.* TO 'maxuser'@'localhost';
GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON *.* TO 'maxuser'@'localhost';
GRANT REPLICATION CLIENT on *.* to 'maxuser'@'localhost';
GRANT REPLICATION SLAVE ON *.* TO 'maxuser'@'localhost';

create user 'rpluser'@'%' identified by 'rplpwd';
GRANT REPLICATION CLIENT on *.* to 'rpluser'@'%';
GRANT REPLICATION SLAVE ON *.* TO 'rpluser'@'%';
grant SELECT on mysql.user to 'rpluser'@'%';
GRANT SELECT ON mysql.db TO 'rpluser'@'%';
GRANT SELECT ON mysql.tables_priv TO 'rpluser'@'%';
GRANT SUPER ON *.* TO 'rpluser'@'%';
grant RELOAD on *.* to 'rpluser'@'%';
GRANT SHOW DATABASES ON *.* TO 'rpluser'@'%';
GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON *.* TO 'rpluser'@'%';

create user 'rpluser'@'localhost' identified by 'rplpwd';
GRANT REPLICATION CLIENT on *.* to 'rpluser'@'localhost';
GRANT REPLICATION SLAVE ON *.* TO 'rpluser'@'localhost';
grant SELECT on mysql.user to 'rpluser'@'localhost';
GRANT SELECT ON mysql.db TO 'rpluser'@'localhost';
GRANT SELECT ON mysql.tables_priv TO 'rpluser'@'localhost';
GRANT SUPER ON *.* TO 'rpluser'@'localhost';
grant RELOAD on *.* to 'rpluser'@'localhost';
GRANT SHOW DATABASES ON *.* TO 'rpluser'@'localhost';
GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON *.* TO 'rpluser'@'localhost';

CREATE USER 'cdcuser'@'%' IDENTIFIED BY 'cdcpwd';
GRANT REPLICATION SLAVE ON *.* TO 'cdcuser'@'%';
GRANT SELECT ON mysql.user TO 'cdcuser'@'%';
GRANT SELECT ON mysql.db TO 'cdcuser'@'%';
GRANT SELECT ON mysql.tables_priv TO 'cdcuser'@'%';
GRANT SELECT ON mysql.roles_mapping TO 'cdcuser'@'%';
GRANT SHOW DATABASES ON *.* TO 'cdcuser'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'cdcuser'@'%';

CREATE USER 'cdcuser'@'localhost' IDENTIFIED BY 'cdcpwd';
GRANT REPLICATION SLAVE ON *.* TO 'cdcuser'@'localhost';
GRANT SELECT ON mysql.user TO 'cdcuser'@'localhost';
GRANT SELECT ON mysql.db TO 'cdcuser'@'localhost';
GRANT SELECT ON mysql.tables_priv TO 'cdcuser'@'localhost';
GRANT SELECT ON mysql.roles_mapping TO 'cdcuser'@'localhost';
GRANT SHOW DATABASES ON *.* TO 'cdcuser'@'localhost';
GRANT REPLICATION CLIENT ON *.* TO 'cdcuser'@'localhost';

RESET MASTER;
RESET SLAVE;

DELIMITER |
IF @@server_id  > 1 THEN
  CHANGE MASTER TO
    MASTER_HOST='127.0.0.1',
    MASTER_USER='maxuser',
    MASTER_PASSWORD='maxpwd',
    MASTER_PORT=33061,
    MASTER_CONNECT_RETRY=10,
    master_use_gtid=current_pos;
  START SLAVE;
END IF |
DELIMITER ;

