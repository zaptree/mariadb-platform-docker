# MariaDB Platform Single Container Image
## Overview

This project combines all of the elements of MariaDB platform into a single container.  This provides an easy way to get your familiar with the many parts of Platform without having to manually setup and configure the various components. This single container image is intended for test and development environments and should **not be used for production deployments**.

Note: Packing multiple processes and services into a single container runs somewhat counter to the principles of containerizing software, but this approach provides a convenient mechanism for delivering all the components of MariaDB platform.

## Instructions


### Download
You have a couple options for downloading and running the MariaDB Platform Single Container Image.

#### Docker command line via Docker Hub
Provided your local docker environment is configured to pull from Docker Hub

`docker pull mariadb/platform_single:x3-1.0`

#### Clone github Repository and build Image

`git clone git@github.com:mariadb-corporation/mariadb-platform-docker.git`

`cd mariadb-platform-docker/single-container`

`docker build . -t mariadb/platform_single:x3-1.0`

### Running Image

`docker run --name mariadb-platform mariadb/platform_single:x3-1.0`

While it is possible to expose Maxsacle RTR to your host machine and issue SQL to the image, opening a shell prompt on the image will allow you explore MariaDB Platform.  You will also use this shell access to reconfigure components as required for your testing.

`docker exec -it mariadb-platform /bin/bash`

If you do want to expose the Maxscale RTR port to your host machine, you need to publish the port with the -p flag when running the image.

`docker run -p 3306:33061/tcp --name mariadb-platform mariadb/platform_single:x3-1.0`

### Architecture
The image has been setup to allow testing of hybrid transactional analytical processing (HTAP), and the basic components are outlines in [this](https://mariadb.com/kb/en/library/sample-platform-x3-implementation-for-transactional-and-analytical-workloads/) knowledgebase article. The major differences include running a three member MariaDB Server Master-Slave cluster (instead of four member), and a simple one UM and one PM MariaDB Columnstore setup.  (The image is still big, even having opted for this trimmed down approach).

![Single Container Architecture Diagram](images/single-container-architecture.png)


### Base Image and Utilities
The Platform Single Container Image sources its base image from the [Columnstore Single Node](https://github.com/mariadb-corporation/mariadb-columnstore-docker/tree/master/columnstore) docker image.  This means that it based on Centos 7, and has installed the runit utility for init and service supervision.

You can find all of the service definitions at `/ect/service` For example `/ect/service/mariadb-maxscale-rtr/run` show the startup command for the Maxscale router service. Importantly, this shows that the Maxscale router service reads a configuration file located at `/etc/mariadb-maxscale-rtr.cnf`

Stopping and starting the services is done with standard runit commands.

```
sv down mariadb-maxscale-rtr
sv up mariadb-maxscale-rtr
sv restart mariadb-maxscale-rtr
```

Between inspecting services, editing config files, and restarting services, you have the means to reconfigure MariaDB Platform to match your requirements.

### MariaDB Columnstore

| Item | Value |
| --- | --- |
| O/S user | `root` |
| Install location | `/usr/local/mariadb/columnstore` |
| Service definition | `/etc/service/columnstore` |
| Config file | `/usr/local/mariadb/columnstore/mysql` |
| Log file directory | `/var/log/mariadb/columnstore` |

### MariaDB Server Master/Slave

| Item | Value |
| --- | --- |
| O/S user | `mysql2` |
| Install location | `/usr/local/mysql/` |
| Service definitions | `/etc/service/mariadb-server-1  /etc/service/mariadb-server-2  /etc/service/mariadb-server-3`  |
| Config files | `/etc/mariadb-server-1.cnf  mariadb-server-2.cnf  mariadb-server-3.cnf` |
| Log files | `/var/log/mysqld1.log  /var/log/mysqld2.log  /var/log/mysqld3.log` |

### MariaDB Maxscale Router

| Item | Value |
| --- | --- |
| O/S user | `maxscale` |
| Install location | `/usr/bin` |
| Service definition | `/etc/service/mariadb-maxscale-rtr` |
| Config file | `/etc/mariadb-maxscale-rtr.cnf` |
| Log file(s) | `/var/log/maxscale/maxscale.log` |

### MariaDB Maxscale CDC

| Item | Value |
| --- | --- |
| O/S user | `maxscale` |
| Install location | `/usr/bin` |
| Service definition | `/etc/service/mariadb-maxscale-cdc` |
| Config file | `/etc/mariadb-maxscale-cdc.cnf` |
| Log file(s) | `/var/log/maxscale-cdc/maxscale.log` |

### MariaDB MXS Adapter

| Item | Value |
| --- | --- |
| O/S user | `root` |
| Install location | `/usr/bin` |
| Service definition | not service enabled |
| Config file | per run |
| Log file(s) | per run |

## Issues, Comments and Suggestions

Please use the github issue feature to provide any and all feedback.

## Errata and Future Enhancements

- MariaDB MXS Adapter should run as a service
