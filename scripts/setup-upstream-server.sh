#! /bin/bash

apt update;

if ! command -v docker info &> /dev/null
then
    echo "docker was not found installing docker ...";
    apt install docker.io;
fi

if ! command -v docker-compose -v &> /dev/null
then
    echo "docker compose not found installing docker-compose ...";
    apt install docker-compose;
fi


if ! command -v uuidgen &> /dev/null
then
    echo "uuidgen not found! installing uuid-runtime";
    apt install uuid-runtime;
fi

# Generate UUID
UPSTREAM_UUID=$(uuidgen)
sed_pattern=`echo s/\<UPSTREAM-UUID\>/$UPSTREAM_UUID/g`
sed -i $sed_pattern ../v2ray-upstream-server/config/config.json;

cd ../v2ray-upstream-server

docker-compose up -d

echo "Success! Your UUID for this server is: ${UPSTREAM_UUID}"