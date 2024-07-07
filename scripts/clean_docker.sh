#!/bin/bash
set -x

./check_disk.sh
docker system prune -af
docker image prune -af
docker system prune -af --volumes
docker system df
docker volume prune -af
./check_disk.sh
