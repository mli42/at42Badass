#!/usr/bin/env sh

# GNS3 start command: sh router.sh >> /var/log/badass

LOG_FILE="/var/log/badass"
HOST_ID=$(echo ${HOSTNAME} | sed -E 's/.+-//')
echo "This is: ${HOSTNAME}" >> ${LOG_FILE}

# Add TARGET_ID and parameter static/multicast

ip link add br0 type bridge
ip link set dev br0 up
ip addr add 10.1.1.2/24 dev eth0

# ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.1 local 10.1.1.2 dstport 4789
# ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789

ip addr add 20.1.1.2/24 dev vxlan10
ip link set dev vxlan10 up
brctl addif br0 eth1
brctl addif br0 vxlan10

/usr/lib/frr/docker-start &
tail -f ${LOG_FILE}
