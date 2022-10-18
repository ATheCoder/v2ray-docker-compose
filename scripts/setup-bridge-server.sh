#! /bin/bash

apt update;

UPSTREAM_UUID=$1

UPSTREAM_IP=$2

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
BRIDGE_UUID=$(uuidgen)
sed_pattern_bridge_uuid=`echo s/\<BRIDGE-UUID\>/$BRIDGE_UUID/g`
gsed -i $sed_pattern_bridge_uuid ../v2ray-bridge-server/config/config.json;
sed_pattern_upstream_ip=`echo s/\<UPSTREAM-IP\>/$UPSTREAM_IP/g`
gsed -i $sed_pattern_upstream_ip ../v2ray-bridge-server/config/config.json;
sed_pattern_upstream_ip=`echo s/\<UPSTREAM-UUID\>/$UPSTREAM_UUID/g`
gsed -i $sed_pattern_upstream_ip ../v2ray-bridge-server/config/config.json;

SHADOWSOCKS_PASS=$(openssl rand -base64 16)
sed_pattern_ss_pass=`echo s/\<SHADOWSOCKS-PASSWORD\>/$SHADOWSOCKS_PASS/g`
gsed -i $sed_pattern_ss_pass ../v2ray-bridge-server/config/config.json;

cd ../v2ray-upstream-server

docker-compose up -d

echo "Success! Your UUID for the bridge server is: ${BRIDGE_UUID}"
echo "Your ShadowSocks Password is: ${SHADOWSOCKS_PASS}"