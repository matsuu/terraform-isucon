provider "google" {
    account_file = "${file(var.account_file)}"
    project = "${var.project}"
    region = "${format("%s-%s",split("-",var.zone))}" # GOOGLE_REGION environemnt variable
}

resource "google_compute_network" "default" {
    name = "${var.name}"
    ipv4_range = "${var.ipv4_range}"
}

resource "google_compute_firewall" "ssh" {
    name = "${var.name}-ssh"
    network = "${google_compute_network.default.name}"
    allow {
        protocol = "tcp"
        ports = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["bench", "image"]
}

resource "google_compute_firewall" "http" {
    name = "${var.name}-http"
    network = "${google_compute_network.default.name}"
    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["image"]
}

resource "google_compute_firewall" "mysql" {
    name = "${var.name}-mysql"
    network = "${google_compute_network.default.name}"
    allow {
        protocol = "tcp"
        ports = ["3306"]
    }

    source_tags = ["bench"]
    target_tags = ["image"]
}

resource "google_compute_instance" "bench" {
    name = "${var.name}-bench"
    machine_type = "${var.bench_machine_type}"
    disk {
        image = "${var.bench_disk_image}"
    }
    zone = "${var.zone}"
    tags = ["bench"]
    network_interface {
        network = "${google_compute_network.default.name}"
        access_config { }
    }
    metadata_startup_script = <<SCRIPT
#!/bin/sh
set -e
echo "Defaults:root !requiretty" >> /etc/sudoers
apt-get update
apt-get -y install ansible git
git clone https://github.com/isucon/isucon5-qualify.git
(
    cd isucon5-qualify/gcp/bench/ansible/
    echo localhost ansible_connection=local > local
    PYTHONUNBUFFERED=1 ansible-playbook -i local 00_devel.yml 01_isucon_base.yml 02_xbuild_part.yml 06_deploy_bench_tool.yml
)
systemctl stop agent.ruby
systemctl disable agent.ruby
echo "/dev/sda1       /        ext4   defaults        0 0" > /etc/fstab
sudo -u isucon bash -c '(source /home/isucon/.bashrc;echo $JAVA_HOME;cd /home/isucon/isucon5-qualify/bench/; gradle compileJava)' 
#git clone https://github.com/matsuu/ansible-isucon.git
#(
#    cd ansible-isucon/isucon5-qualifier
#    PYTHONUNBUFFERED=1 ansible-playbook -i local bench.yml
#)
#rm -rf ansible-isucon
SCRIPT
}

resource "google_compute_instance" "image" {
    name = "${var.name}-image"
    machine_type = "${var.image_machine_type}"
    disk {
        image = "${var.image_disk_image}"
    }
    zone = "${var.zone}"
    tags = ["image"]
    network_interface {
        network = "${google_compute_network.default.name}"
        access_config { }
    }
}
