# MariaDB Platform Single Container Image
## Overview

This project combines all of the elements of MariaDB platform into a single container.  This provides an easy way to get your familiar with the many parts of Platform without having to manually setup and configure the various components. This single container image is intended for test and development environments, though can serve as a template for production deployments.

## Instructions


### Download
You have several options for downloading and running the MariaDB Platform Single Container Image.
#### Download from MariaDB.com
Download the image file at mariadb.com/downloads

This is a saved image file and can be added to your local images with the following command

`docker load < mariadb_platform_single_x3-10.tar`

#### Docker command line via Docker Hub
Provided your local docker environment is configured to pull from Docker Hub

`docker pull mariadb/platform_single:x3-1.0`

#### Clone github Repository and build Image

`git clone git@github.com:mariadb-corporation/mariadb-platform-docker.git`
`cd mariadb-platform-docker/single-container`
`docker build . -t mariadb/platform-single:x3-1.0`

### Running Image
This section will receive many updates to explain the inner workings of the image.  For now

`docker run --name mariadb-platform mariadb/platform-single:x3-1.0`
`docker exec -it mariadb-platform /bin/bash`

## Issues, Comments and Suggestions

Please use the github issue feature to provide any and all feedback.

## Errata and Future Enhancements