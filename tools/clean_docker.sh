#!/usr/bin/env bash
# Script for Purging Containers, Images, Volumes and Networks related to Docker.

# Destroy containers
docker rm -f $(docker ps -aq)

# Destroy images
docker rmi -f $(docker images -q)

# Destroy volumes
docker volume rm -f $(docker volume ls -q)

# Destroy Networks
docker network rm $(docker network ls -q)
