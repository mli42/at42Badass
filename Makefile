DEBIAN_ISO := debian-11.6.0-amd64-netinst.iso
DEBIAN_URL := https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/${DEBIAN_ISO}
QEMU_HDA := bgp.qcow2
NPROC := ${shell nproc}

SSH_IP := localhost
SSH_USER := ${shell whoami}
SSH_HOST := ${SSH_USER}@${SSH_IP}
SSH_PORT := 5000

.PHONY: all
all: ${DEBIAN_ISO} ${QEMU_HDA}
	qemu-system-x86_64 -cdrom ${DEBIAN_ISO} \
		-hda ${QEMU_HDA} \
		-enable-kvm \
		-machine q35 \
		-cpu host \
		-m 12G \
		-smp ${NPROC} \
		-net user,hostfwd=tcp::${SSH_PORT}-:22 \
		-net nic &

${DEBIAN_ISO}:
	curl -L ${DEBIAN_URL} -o $@

${QEMU_HDA}:
	qemu-img create -f qcow2 $@ 20G

.PHONY: ssh
ssh:
	ssh ${SSH_HOST} -p ${SSH_PORT}

# should be used like this: make upload_p1 / make upload_bonus
upload_%:
	scp -P ${SSH_PORT} -r ${*} ${SSH_HOST}:.

# should be used like this: make download_p1 / make download_bonus
download_%:
	scp -P ${SSH_PORT} -r ${SSH_HOST}:${*} .
