provider "google" {
    account_file = "${file(var.account_file)}"
    project = "${var.project}"
    region = "${format("%s-%s",split("-",var.zone))}" # GOOGLE_REGION environemnt variable
}

resource "google_compute_network" "default" {
    name = "${var.bench_name}"
    ipv4_range = "${var.ipv4_range}"
}

resource "google_compute_firewall" "default" {
    name = "${var.bench_name}"
    network = "${google_compute_network.default.name}"
    allow {
        protocol = "tcp"
        ports = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["${var.bench_name}"]
}

resource "google_compute_instance" "bench" {
    name = "${var.bench_name}"
    machine_type = "${var.bench_machine_type}"
    disk {
        image = "${var.bench_disk_image}"
    }
    zone = "${var.zone}"
    tags = ["${var.bench_name}"]
    network_interface {
        network = "${google_compute_network.default.name}"
        access_config { }
    }
    metadata_startup_script = <<SCRIPT
#!/bin/sh
set -e
echo "Defaults:root !requiretty" >> /etc/sudoers
apt-get update
apt-get -y install ansible jq git language-pack-ja
update-locale LANG=ja_JP.UTF-8
git clone https://github.com/isucon/isucon5-qualify.git
(
    cd isucon5-qualify/gcp/bench/ansible/
    sed -i 's/- copy/#- copy/' 00_devel.yml
    sed -i 's@key_file=.*@@' 06_deploy_bench_tool.yml
    sed -i 's@repo=.*@repo=https://github.com/isucon/isucon5-qualify.git@' 06_deploy_bench_tool.yml
    echo localhost ansible_connection=local > local
    PYTHONUNBUFFERED=1 ansible-playbook -i local 00_devel.yml 01_isucon_base.yml 02_xbuild_part.yml 06_deploy_bench_tool.yml
)
systemctl stop agent.ruby
systemctl disable agent.ruby
echo "/dev/sda1       /        ext4   defaults        0 0" > /etc/fstab
sudo -u isucon bash -c '(source /home/isucon/.bashrc;echo $JAVA_HOME;cd /home/isucon/isucon5-qualify/bench/; gradle compileJava)' 
SCRIPT
}
