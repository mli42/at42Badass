#!/usr/bin/env sh

# GNS3 start command: sh p3_host.sh

LOG_FILE="/var/log/badass"
exec 3<&1 2>&1 1>${LOG_FILE}

HOST_ID=$(echo ${HOSTNAME} | sed -E 's/.+-//')
echo "This is: ${HOSTNAME}"

# Give IP address to the machines on eth0 device
ip addr add 20.1.1.${HOST_ID}/24 dev eth0

tail -f -n +0 ${LOG_FILE} >&3
