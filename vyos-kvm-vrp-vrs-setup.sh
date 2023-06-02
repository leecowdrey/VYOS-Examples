rm -f /var/lib/libvirt/images/vrp.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vrp.qcow2 8G && virsh undefine vrp

rm -f /var/lib/libvirt/images/vrs.qcow2 && qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/vrs.qcow2 8G && virsh undefine vrs

virt-install -n vrp \
  --ram 4096 \
  --vcpus 2 \
  --cdrom /var/lib/libvirt/images/vyos-1.2.6-S1-amd64.iso \
  --os-type linux \
  --os-variant debian9 \
  --network bridge=br0,model=virtio \
  --graphics vnc,password=Pa33word,listen=192.168.30.253,port=5908 \
  --hvm \
  --virt-type kvm \
  --disk path=/var/lib/libvirt/images/vrp.qcow2,bus=virtio,size=8 \
  --noautoconsole

virt-install -n vrs \
  --ram 4096 \
  --vcpus 2 \
  --cdrom /var/lib/libvirt/images/vyos-1.2.6-S1-amd64.iso \
  --os-type linux \
  --os-variant debian9 \
  --network bridge=br0,model=virtio \
  --graphics vnc,password=Pa33word,listen=192.168.30.253,port=5909 \
  --hvm \
  --virt-type kvm \
  --disk path=/var/lib/libvirt/images/vrs.qcow2,bus=virtio,size=8 \
  --noautoconsole

virsh autostart vrp
virsh autostart vrs

virsh dumpxml vrp > /root/vrp.xml
virsh dumpxml vrs > /root/vrs.xml
cp /var/lib/libvirt/images/vrp.qcow2 /root/
cp /var/lib/libvirt/images/vrs.qcow2 /root/

virsh start vrp
virsh start vrs

