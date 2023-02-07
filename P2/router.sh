#!/usr/bin/env sh

# GNS3 start command: sh router.sh <staticcast/multicast> >> /var/log/badass

LOG_FILE="/var/log/badass"
HOST_ID=$(echo ${HOSTNAME} | sed -E 's/.+-//')
TARGET_ID=$([ "${HOST_ID}" -ne "1" ] && echo 1 || echo 2)
echo "This is: ${HOSTNAME}" >> ${LOG_FILE}

CASTTYPE="${1}"
STATIC_CAST="staticcast"
MULTI_CAST="multicast"

if [ "${CASTTYPE}" != "${STATIC_CAST}" -a "${CASTTYPE}" != "${MULTI_CAST}" ]; then
  echo "First parameter must be '${STATIC_CAST}' or '${MULTI_CAST}'"
  exit 1
fi

# Create a bridge interface to connect the hosts with the VXLAN
# Then turn on to "up" state
ip link add br0 type bridge
ip link set dev br0 up

# Assign IP address to eth0 (10.1.1.1 for router-1 and 10.1.1.2 for router-2)
ip addr add 10.1.1.${HOST_ID}/24 dev eth0

# Create the VXLAN interface
if [ "${CASTTYPE}" == "${STATIC_CAST}" ]; then
  ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.${TARGET_ID} local 10.1.1.${HOST_ID} dstport 4789
else
  ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
fi

# Assign IP address to vxlan10 device (20.1.1.1 for router-1 and 20.1.1.2 for router-2)
ip addr add 20.1.1.${HOST_ID}/24 dev vxlan10

# Turn the VXLAN on to "up" state
ip link set dev vxlan10 up

# bridge control add interface (eth1 and vxlan10) to bridge's domain
brctl addif br0 eth1
brctl addif br0 vxlan10

echo "You can inspect with:"
echo "- ip -d link show vxlan10"
echo "- ip addr show eth0"

/usr/lib/frr/docker-start >> ${LOG_FILE} &
tail -f ${LOG_FILE}
