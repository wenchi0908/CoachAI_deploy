#!/bin/bash
docker-compose -f docker-compose_ssl.yml down

echo "======================"
echo "[ ssl certificate ]"
docker-compose -f docker-compose_ssl.yml run -d nginx
docker-compose -f docker-compose_ssl.yml run certbot
docker-compose -f docker-compose_ssl.yml ps
docker-compose -f docker-compose_ssl.yml down

