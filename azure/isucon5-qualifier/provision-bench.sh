#!/bin/sh

set -e

sed -i.bak -e "s@http://us\.archive\.ubuntu\.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@g" /etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ansible git

cd /mnt
git clone https://github.com/matsuu/ansible-isucon.git
(
  cd ansible-isucon/isucon5-qualifier
  PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i local bench/ansible/playbook.yml
)
rm -rf ansible-isucon
