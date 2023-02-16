#!/usr/bin/env sh

echo "Starting the leaf script..."
HOST_ID=$(echo ${HOSTNAME} | sed -E 's/.+-//')
ETH1_ID=$(echo "(${HOST_ID} - 2) * 4 + 2" | bc)

# Create a bridge interface, then turn on to "up" state
ip link add br0 type bridge
ip link set dev br0 up

# Create the VXLAN interface
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up

# Connect interfaces eth1 and vxlan10, via bridge
brctl addif br0 vxlan10
brctl addif br0 eth0

vtysh << EOF
config t
hostname ${HOSTNAME}
no ipv6 forwarding
!
! Configure IP address of interfaces 'eth1' and 'lo', and assign OSPF zone
!
interface eth1
 ip address 10.1.1.${ETH1_ID}/30
 ip ospf area 0
interface lo
 ip address 1.1.1.${HOST_ID}/32
 ip ospf area 0
!
! Define neighborhood at IP 1.1.1.1, AS number 1
!
router bgp 1
 neighbor 1.1.1.1 remote-as 1
 neighbor 1.1.1.1 update-source lo
 !
 address-family l2vpn evpn
  neighbor 1.1.1.1 activate
  advertise-all-vni
 exit-address-family
!
router ospf
EOF
