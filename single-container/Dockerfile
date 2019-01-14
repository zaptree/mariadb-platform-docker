FROM mariadb/columnstore:1.2.2

## Change Columnstore port to 4306
RUN sed -i 's/postConfigure -n/postConfigure -port 4306 -n/g' /usr/sbin/dbinit

## Create home directory for mysql, which is the user executing Columnstore processes
RUN mkdir /home/mysql
RUN chown mysql /home/mysql
RUN chgrp mysql /home/mysql

## Install wget for downloads later in script
RUN yum -y update
RUN yum -y install wget

## Install MariaDB-Server
##   Default installs from RPM or REPO will conflict with base Columnstore installation, so a
##   laydown of binaries is done into different directory, and a symbolic link is created.
RUN wget https://downloads.mariadb.org/interstitial/mariadb-10.3.12/bintar-linux-x86_64/mariadb-10.3.12-linux-x86_64.tar.gz
RUN tar -zxvpf mariadb-10.3.12-linux-x86_64.tar.gz
RUN rm mariadb-10.3.12-linux-x86_64.tar.gz
RUN mv mariadb-10.3.12-linux-x86_64 /usr/local

## Create mysql2 whole will run the MariaDB Server processes
RUN groupadd -r mysql2
RUN useradd -r -g mysql2 mysql2
RUN mkdir /home/mysql2
RUN chown mysql2 /home/mysql2
RUN chgrp mysql2 /home/mysql2

RUN chown -R mysql2 /usr/local/mariadb-10.3.12-linux-x86_64
RUN chgrp -R mysql2 /usr/local/mariadb-10.3.12-linux-x86_64
RUN ln -s /usr/local/mariadb-10.3.12-linux-x86_64 /usr/local/mysql
RUN chown -R mysql2 /usr/local/mysql
RUN chgrp -R mysql2 /usr/local/mysql
RUN echo "export PATH=$PATH:/usr/local/mysql/bin" >> /root/.bashrc
RUN sudo -u mysql2 echo "export PATH=$PATH:/usr/local/mysql/bin" >> /home/mysql2/.bashrc

## Cleanup some unneeded files
## These next two lines attempt to free up diskspace to make docker image smaller
RUN sudo rm -R /usr/local/mysql/bin/*embedded* /usr/local/mysql/bin/aria* /usr/local/mysql/bin/test-connect-t
RUN sudo rm -R /usr/local/mysql/bin/*test*
RUN sudo rm -R /usr/local/mariadb-10.3.*/mysql-test
RUN sudo rm -R /usr/local/mariadb-10.3.12-linux-x86_64/lib/plugin/ha_cassandra.so
RUN sudo rm -R /usr/local/mariadb-10.3.12-linux-x86_64/lib/plugin/ha_connect.so
RUN sudo rm -R /usr/local/mariadb-10.3.12-linux-x86_64/lib/plugin/ha_mroonga.so
RUN sudo rm -R /usr/local/mariadb-10.3.12-linux-x86_64/lib/plugin/ha_tokudb.so

## Configuration changes to get MariaDB Server to run as a 3-node Master/Slave cluster using the
## mysqld_multi feature

RUN mkdir -p /var/lib/mysql/{1,2,3}
RUN chown -R mysql2 /var/lib/mysql
RUN chgrp -R mysql2 /var/lib/mysql
RUN touch /var/log/mysqld{1,2,3}.log
RUN chmod o-r /var/log/mysqld{1,2,3}.log
RUN chown -R mysql2 /var/log/mysqld{1,2,3}.log
RUN chgrp -R mysql2 /var/log/mysqld{1,2,3}.log

## Copy custom my.cnf script which is setup to run mysqld_multi to start 3 node cluster
COPY scripts/mariadb-server-1.cnf /etc/
COPY scripts/mariadb-server-2.cnf /etc/
COPY scripts/mariadb-server-3.cnf /etc/
RUN chown mysql2 /etc/mariadb-server-1.cnf
RUN chown mysql2 /etc/mariadb-server-2.cnf
RUN chown mysql2 /etc/mariadb-server-3.cnf

## Copy scripts for initializing the 3 node MariaDB Server cluster
RUN mkdir -p /root/scripts
COPY scripts/*    /home/mysql2/scripts/
RUN chown -R mysql2 /home/mysql2/scripts
RUN chgrp mysql2 /home/mysql2/scripts
RUN chmod +x /home/mysql2/scripts/*.sh
RUN mkdir -p /var/run/mysqld/
RUN chown mysql2 /var/run/mysqld
RUN chgrp mysql2 /var/run/mysqld

## Initialize the 3 node MariaDB Server cluster
RUN sed -i 's/secure_path = \/sbin:\/bin:\/usr\/sbin:\/usr\/bin/secure_path = \/sbin:\/bin:\/usr\/sbin:\/usr\/bin:\/usr\/local\/mysql\/bin/g' /etc/sudoers
RUN /home/mysql2/scripts/mariadb-server-ms-init.sh

## Copy service scripts that will cause MariaDB Server cluster to start on container startup
RUN mkdir -p /etc/service/mariadb-server-{1,2,3}

COPY service/mariadb-server-1/run /etc/service/mariadb-server-1/run
RUN chmod 755 /etc/service/mariadb-server-1/run
COPY service/mariadb-server-1/run /etc/service/mariadb-server-1/finish
RUN chmod 755 /etc/service/mariadb-server-1/finish

COPY service/mariadb-server-2/run /etc/service/mariadb-server-2/run
RUN chmod 755 /etc/service/mariadb-server-2/run
COPY service/mariadb-server-2/finish /etc/service/mariadb-server-2/finish
RUN chmod 755 /etc/service/mariadb-server-2/finish


COPY service/mariadb-server-3/run /etc/service/mariadb-server-3/run
RUN chmod 755 /etc/service/mariadb-server-3/run
COPY service/mariadb-server-3/finish /etc/service/mariadb-server-3/finish
RUN chmod 755 /etc/service/mariadb-server-3/finish

## Install Maxscale
RUN wget https://downloads.mariadb.com/MaxScale/2.3.2/centos/7/x86_64/maxscale-2.3.2-1.centos.7.x86_64.rpm
RUN yum -y install maxscale-2.*.rpm
RUN rm /maxscale-2.*.rpm
COPY scripts/mariadb-maxscale-rtr.cnf /etc/mariadb-maxscale-rtr.cnf
RUN chown mysql /etc/mariadb-maxscale-rtr.cnf

## Install the Columnstore Bulk Write SDK C/C++ (required by Columnstore CDC Connector)
RUN wget https://downloads.mariadb.com/Data-Adapters/mariadb-columnstore-api/1.2.2/centos/x86_64/7/mariadb-columnstore-api-1.2.2-1-x86_64-centos7-cpp.rpm
RUN yum -y install mariadb-columnstore-api-1.2.2-1-x86_64-centos7-cpp.rpm
RUN rm mariadb-columnstore-api-1.2.2-1-x86_64-centos7-cpp.rpm

## Install Columnstore CDC Connector
RUN wget https://downloads.mariadb.com/MaxScale/2.2.18/centos/7/x86_64/maxscale-cdc-connector-2.2.18-1.centos.7.x86_64.rpm
RUN yum -y install maxscale-cdc-connector-2.2.18-1.centos.7.x86_64.rpm
RUN rm maxscale-cdc-connector-2.2.18-1.centos.7.x86_64.rpm

