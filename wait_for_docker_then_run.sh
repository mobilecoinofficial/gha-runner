#!/bin/bash

# Wait for docker socket to exist.

docker_socket=/run/docker/docker.sock
count=0

while [[ ! -S "${docker_socket}" ]]
do
    echo "Waiting for ${docker_socket}"
    sleep 1

    count=$((count+1))
    if [[ ${count} -gt 60 ]]
    then
        echo "Timed out waiting for docker socket"
        exit 1
    fi
done

/home/runner/run.sh
