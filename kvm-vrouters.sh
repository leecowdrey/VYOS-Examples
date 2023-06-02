rm -f /var/lib/libvirt/images/vr-core.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vr-core.qcow2 2G && virsh undefine vr-core
rm -f /var/lib/libvirt/images/vr-tentel.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vr-tentel.qcow2 2G && virsh undefine vr-tentel
rm -f /var/lib/libvirt/images/vr-cameras.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vr-cameras.qcow2 2G && virsh undefine vr-cameras
rm -f /var/lib/libvirt/images/vr-general.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vr-general.qcow2 2G && virsh undefine vr-general
rm -f /var/lib/libvirt/images/vr-ott.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vr-ott.qcow2 2G && virsh undefine vr-ott
rm -f /var/lib/libvirt/images/vr-security.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vr-security.qcow2 2G && virsh undefine vr-security
rm -f /var/lib/libvirt/images/vr-wan.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vr-wan.qcow2 2G && virsh undefine vr-wan

chown libvirt-qemu:kvm /var/lib/libvirt/images/vr-core.qcow2
chown libvirt-qemu:kvm /var/lib/libvirt/images/vr-tentel.qcow2
chown libvirt-qemu:kvm /var/lib/libvirt/images/vr-cameras.qcow2
chown libvirt-qemu:kvm /var/lib/libvirt/images/vr-general.qcow2
chown libvirt-qemu:kvm /var/lib/libvirt/images/vr-ott.qcow2
chown libvirt-qemu:kvm /var/lib/libvirt/images/vr-security.qcow2
chown libvirt-qemu:kvm /var/lib/libvirt/images/vr-wan.qcow2

virt-install \
--name vr-core \
--ram 2048 \
--disk path=/var/lib/libvirt/images/vr-core.qcow2,size=2,format=qcow2,bus=virtio,cache=none \
--vcpus 2 \
--os-type=linux \
--os-variant=debian8 \
--network=network,source=br90,model=virtio \
--graphics none \
--cdrom /srv/iso/vyos-1.2.1-amd64.iso

virt-install \
--name vr-tentel \
--ram 1024 \
--disk path=/var/lib/libvirt/images/vr-tentel.qcow2,size=2,format=qcow2,bus=virtio,cache=none \
--vcpus 2 \
--os-type=linux \
--os-variant=debian8 \
--network=network,source=br90,model=virtio \
--network=network,source=br10,model=virtio \
--graphics none \
--cdrom /srv/iso/vyos-1.2.1-amd64.iso

virt-install \
--name vr-cameras \
--ram 1024 \
--disk path=/var/lib/libvirt/images/vr-cameras.qcow2,size=2,format=qcow2,bus=virtio,cache=none \
--vcpus 2 \
--os-type=linux \
--os-variant=debian8 \
--network=network,source=br90,model=virtio \
--network=network,source=br20,model=virtio \
--graphics none \
--cdrom /srv/iso/vyos-1.2.1-amd64.iso

virt-install \
--name vr-general \
--ram 1024 \
--disk path=/var/lib/libvirt/images/vr-general.qcow2,size=2,format=qcow2,bus=virtio,cache=none \
--vcpus 2 \
--os-type=linux \
--os-variant=debian8 \
--network=network,source=br90,model=virtio \
--network=network,source=br30,model=virtio \
--graphics none \
--cdrom /srv/iso/vyos-1.2.1-amd64.iso

virt-install \
--name vr-ott \
--ram 1024 \
--disk path=/var/lib/libvirt/images/vr-ott.qcow2,size=2,format=qcow2,bus=virtio,cache=none \
--vcpus 2 \
--os-type=linux \
--os-variant=debian8 \
--network=network,source=br90,model=virtio \
--network=network,source=br40,model=virtio \
--graphics none \
--cdrom /srv/iso/vyos-1.2.1-amd64.iso

virt-install \
--name vr-security \
--ram 1024 \
--disk path=/var/lib/libvirt/images/vr-security.qcow2,size=2,format=qcow2,bus=virtio,cache=none \
--vcpus 2 \
--os-type=linux \
--os-variant=debian8 \
--network=network,source=br90,model=virtio \
--network=network,source=br80,model=virtio \
--graphics none \
--cdrom /srv/iso/vyos-1.2.1-amd64.iso

virt-install \
--name vr-wan \
--ram 2048 \
--disk path=/var/lib/libvirt/images/vr-wan.qcow2,size=2,format=qcow2,bus=virtio,cache=none \
--vcpus 2 \
--os-type=linux \
--os-variant=debian8 \
--network=network,source=br90,model=virtio \
--network=network,source=br100,model=virtio \
--graphics none \
--cdrom /srv/iso/vyos-1.2.1-amd64.iso

virsh autostart vr-core
virsh autostart vr-tentel
virsh autostart vr-cameras
virsh autostart vr-general
virsh autostart vr-ott
virsh autostart vr-security
virsh autostart vr-wan

virsh dumpxml vr-core > /root/vr-core.xml
virsh dumpxml vr-tentel > /root/vr-tentel.xml
virsh dumpxml vr-cameras > /root/vr-cameras.xml
virsh dumpxml vr-general > /root/vr-general.xml
virsh dumpxml vr-ott > /root/vr-ott.xml
virsh dumpxml vr-security > /root/vr-security.xml
virsh dumpxml vr-wan > /root/vr-wan.xml

cp /var/lib/libvirt/images/vr-core.qcow2 /root/vr-core.qcow2.original
cp /var/lib/libvirt/images/vr-tentel.qcow2 /root/vr-tentel.qcow2.original
cp /var/lib/libvirt/images/vr-cameras.qcow2 /root/vr-cameras.qcow2.original
cp /var/lib/libvirt/images/vr-general.qcow2 /root/vr-general.qcow2.original
cp /var/lib/libvirt/images/vr-ott.qcow2 /root/vr-ott.qcow2.original
cp /var/lib/libvirt/images/vr-security.qcow2 /root/vr-security.qcow2.original
cp /var/lib/libvirt/images/vr-wan.qcow2 /root/vr-wan.qcow2.original

virsh start vr-core-primary
virsh start vr-core-secondary
virsh start vr-tentel
virsh start vr-cameras
virsh start vr-general
virsh start vr-ott
virsh start vr-security
virsh start vr-wan

virsh shutdown vr-core-primary
virsh shutdown vr-core-secondary
virsh shutdown vr-tentel
virsh shutdown vr-cameras
virsh shutdown vr-general
virsh shutdown vr-ott
virsh shutdown vr-security
virsh shutdown vr-wan
