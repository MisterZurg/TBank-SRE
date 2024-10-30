#!/bin/bash

echo "Downloading ElasticSearch from Yandex mirror"
wget https://mirror.yandex.ru/mirrors/elastic/8/pool/main/e/elasticsearch/elasticsearch-8.1.1-amd64.deb -O /tmp/elasticsearch-8.1.1-amd64.deb
wget https://mirror.yandex.ru/mirrors/elastic/8/pool/main/k/kibana/kibana-8.1.1-amd64.deb -O /tmp/kibana-8.1.1-amd64.deb

# Install ElasticSearch from Yandex
echo "Installing ElasticSearch + Kibana"
dpkg -i /tmp/elasticsearch-8.1.1-amd64.deb
dpkg -i /tmp/kibana-8.1.1-amd64.deb

# Configure kibana to listen on 0.0.0.0
sed -i "s/^#server.host:.*/server.host: \"0.0.0.0\"/g" /etc/kibana/kibana.yml

# Disable xpack security for elasticsearch
sed -i "s/^xpack.security.enabled:.*/xpack.security.enabled: false/g" /etc/elasticsearch/elasticsearch.yml

# Limit memory for ES to 1Gb
echo "-Xms1g" > /etc/elasticsearch/jvm.options.d/memory-limit.options
echo "-Xmx1g" >> /etc/elasticsearch/jvm.options.d/memory-limit.options

### echo "-Xms1g" > ./memory-limit.options
### echo "-Xmx1g" >> ./memory-limit.options

# Force to listen on 0.0.0.0
sed -i "s/^#network.host:.*/network.host: \"0.0.0.0\"/g" /etc/elasticsearch/elasticsearch.yml
## drwxr-s---   4 root elasticsearch  4096 Oct 28 18:15 elasticsearch
## drwxr-sr--   4 root elasticsearch  4096 Oct 28 18:15 elasticsearch

# Restart Elasticsearch & Kibana
systemctl enable elasticsearch
systemctl enable kibana

systemctl restart elasticsearch
systemctl restart kibana

read -n 1 -p "Please wait for ~5 min for elasticsearch startup"


MYIP=`ifconfig eth0 | grep "inet " | awk '{print $2;}' | head -1`

echo "## Please open http://${MYIP}:5601/"
