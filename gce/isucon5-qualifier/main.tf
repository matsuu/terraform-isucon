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
    target_tags = ["${var.name}-bench", "${var.name}-image"]
}

resource "google_compute_firewall" "http" {
    name = "${var.name}-http"
    network = "${google_compute_network.default.name}"
    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["${var.name}-image"]
}

resource "google_compute_instance" "bench" {
    name = "${var.name}-bench"
    machine_type = "${var.bench_machine_type}"
    disk {
        image = "${var.bench_disk_image}"
    }
    zone = "${var.zone}"
    tags = ["${var.name}-bench"]
    network_interface {
        network = "${google_compute_network.default.name}"
        access_config { }
    }
    metadata_startup_script = <<SCRIPT
#!/bin/sh
set -e
echo "Defaults:root !requiretty" >> /etc/sudoers
apt-get update
apt-get -y install ansible git language-pack-ja
update-locale LANG=ja_JP.UTF-8
git clone https://github.com/isucon/isucon5-qualify.git
(
    cd isucon5-qualify/gcp/bench/ansible/
    echo localhost ansible_connection=local > local
    PYTHONUNBUFFERED=1 ansible-playbook -i local *.yml
)
systemctl stop agent.ruby
systemctl disable agent.ruby
echo "/dev/sda1       /        ext4   defaults        0 0" > /etc/fstab
SCRIPT
}

resource "google_compute_instance" "image" {
    name = "${var.name}-image"
    machine_type = "${var.image_machine_type}"
    disk {
        image = "${var.image_disk_image}"
    }
    zone = "${var.zone}"
    tags = ["${var.name}-image"]
    network_interface {
        network = "${google_compute_network.default.name}"
        access_config { }
    }
}
