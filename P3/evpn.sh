#!/usr/bin/env sh

# GNS3 start command: sh evpn.sh <spine/leaf>

LOG_FILE="/var/log/badass"
exec 3<&1 2>&1 1>${LOG_FILE}
echo "This is: ${HOSTNAME}"

GIVEN_ROLE="${1}"
SPINE="spine"
LEAF="leaf"

if [ "${GIVEN_ROLE}" != "${SPINE}" -a "${GIVEN_ROLE}" != "${LEAF}" ]; then
  echo "First parameter must be '${SPINE}' or '${LEAF}'"
  exit 1
fi

/usr/lib/frr/frrinit.sh start

if [ "${GIVEN_ROLE}" == "${SPINE}" ]; then
  sh ./spine_vtysh.sh
else
  sh ./leaf_vtysh.sh
fi

echo "You can inspect with vtysh (conf t):"
echo "- do sh ip route"
echo "- do sh bgp summary"
echo "- do sh bgp l2vpn evpn"

tail -f -n +0 ${LOG_FILE} >&3
