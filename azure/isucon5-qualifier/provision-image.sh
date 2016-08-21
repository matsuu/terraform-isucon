#!/bin/sh

set -e

sed -i.bak -e "s@http://us\.archive\.ubuntu\.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@g" /etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ansible git mount parted e2fsprogs mdadm

mkfs.btrfs -d raid0 -m raid0 /dev/sd[c-z]
UUID=`blkid /dev/sd[c-z] -s UUID -o value | head -n 1`
echo "UUID=${UUID}	/var/lib/mysql	btrfs	subvol=mysql	0 0" >> /etc/fstab
echo "UUID=${UUID}	/home/isucon/webapp	btrfs	subvol=webapp	0 0" >> /etc/fstab

MOUNT=/mnt/btfs
mkdir -p ${MOUNT}
mount -t btrfs UUID=${UUID} ${MOUNT}

btrfs subvolume create ${MOUNT}/mysql
mkdir -p /var/lib/mysql
#chown -R mysql:mysql ${MOUNT}/mysql /var/lib/mysql
btrfs subvolume create ${MOUNT}/webapp
mkdir -p /home/isucon/webapp
chown -R isucon:isucon ${MOUNT}/webapp /home/isucon

umount ${MOUNT}
mount -a

cd /mnt
git clone https://github.com/matsuu/ansible-isucon.git
(
  cd ansible-isucon/isucon5-qualifier
  sed -i -e "s/mysql-server-5.6/mariadb-server/" image/ansible/03_middleware.yml
  sed -i -e "/sudo_user/d" image/ansible/07_deploy_database.yml
  PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i local image/ansible/playbook.yml
)
rm -rf ansible-isucon
