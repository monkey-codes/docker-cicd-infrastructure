#!/bin/bash
#rm vhost.conf
tee docker-compose.yml <<EOF
version: '3'

services:

  git:
    image: gitea/gitea:1.3.2
    container_name: git
    volumes:
      - ./data/gitea:/data
    ports:
      - "3000:3000"
      - "22:22"
    depends_on:
      - db
    restart: always

  db:
    image: mariadb:10
    container_name: db
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=changeme
      - MYSQL_DATABASE=gitea
      - MYSQL_USER=gitea
      - MYSQL_PASSWORD=changeme
    volumes:
      - ./data/mysql/:/var/lib/mysql

  jenkins:
    image: jenkinsci/blueocean
    container_name: jenkins
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "./data/jenkins:/var/jenkins_home"
    user: root

  nexus:
    image: sonatype/nexus3
    container_name: nexus
    ports:
      - "8081:8081"
    volumes:
      - "./data/nexus:/nexus-data"

  proxy:
    build: ./reverse-proxy
    image: cicd-reverse-proxy
    container_name: reverse-proxy
    links:
       - git
       - jenkins
       - nexus
    ports:
      - "80:80"
    networks:
      default:
        aliases:
EOF
rm reverse-proxy/httpd-vhosts.conf
for var in "$@"
do
  HOST_NAME=$(echo $var | cut -d':' -f1)
  TARGET=$(echo $var | cut -d':' -f2)
  PORT=$(echo $var | cut -d':' -f3)
  tee -a reverse-proxy/httpd-vhosts.conf <<EOF
<VirtualHost $HOST_NAME:80>
  ServerName $HOST_NAME
  ProxyPreserveHost On
  ProxyRequests Off
  ProxyErrorOverride Off
  ErrorLog "logs/vhost-error_log"
  CustomLog "logs/vhost-access_log" common
  ProxyPass / http://$TARGET:$PORT/
  ProxyPassReverse / http://$TARGET:$PORT/
</VirtualHost>
EOF
tee -a docker-compose.yml <<EOF
          - $HOST_NAME
EOF

done
docker-compose build proxy
