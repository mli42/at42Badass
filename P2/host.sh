#!/usr/bin/env sh

# GNS3 start command: sh host.sh

LOG_FILE="/var/log/badass"
exec 3<&1 2>&1 1>${LOG_FILE}

HOST_ID=$(echo ${HOSTNAME} | sed -E 's/.+-//')
echo "This is: ${HOSTNAME}"

# Give IP address to the machines on eth1 device
ip addr add 30.1.1.${HOST_ID}/24 dev eth1

tail -f ${LOG_FILE} >&3
