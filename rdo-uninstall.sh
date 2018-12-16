#!/bin/bash

for x in $(virsh list --all | grep instance- | awk '{print $2}') ; do
    virsh destroy $x ;
    virsh undefine $x ;
done ;

yum remove -y nrpe "*nagios*" puppet "*openstack*" "*nova*" "*keystone*" "*glance*" "*cinder*" "*swift*";

mysql -u root -e "drop database nova; drop database cinder; drop database keystone; drop database glance; drop database neutron;"

# Uncomment this for Cinder volume group
# umount /srv/node/device* ;
# vgremove -f cinder-volumes ;

losetup -a | sed -e 's/:.*//g' | xargs losetup -d ;

find /etc/pki/tls -name "ssl_ps*" | xargs rm -rf ;
for x in $(df | grep "/lib/" | sed -e 's/.* //g') ; do
    umount $x ;
done

ovs-vsctl del-br br-ex
ovs-vsctl del-br br-tun
ovs-vsctl del-br br-int

yum remove -y mysql mysql-server httpd "*memcache*" scsi-target-utils iscsi-initiator-utils perl-DBI perl-DBD-MySQL "*mariadb*" "*MySQL*" openvswitch

rm -rf  /etc/nagios  /etc/mysql /root/.my.cnf /etc/yum.repos.d/packstack_* /var/lib/cinder/ /var/lib/glance /var/lib/nova /etc/nova /srv/node/device*/*  /etc/rsync.d/frag* /var/lib/mysql/ /etc/swift \
/var/cache/swift /var/log/keystone /var/log/nova /var/log/neutron /var/log/cinder /var/log/glance \
/var/log/httpd /var/log/libvirt /var/log/mariadb /var/log/openvswitch /var/log/rabbitmq ;
