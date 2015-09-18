provider "google" {
    account_file = "${file(var.account_file)}"
    project = "${var.project}"
    region = "${format("%s-%s",split("-",var.zone))}" # GOOGLE_REGION environemnt variable
}

resource "google_compute_network" "default" {
    name = "${var.web_name}"
    ipv4_range = "${var.ipv4_range}"
}

resource "google_compute_firewall" "default" {
    name = "${var.web_name}"
    network = "${google_compute_network.default.name}"
    allow {
        protocol = "tcp"
        ports = ["22","80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["${var.web_name}"]
}

resource "google_compute_instance" "web" {
    name = "${var.web_name}"
    machine_type = "${var.web_machine_type}"
    disk {
        image = "${var.web_disk_image}"
    }
    zone = "${var.zone}"
    tags = ["${var.web_name}"]
    network_interface {
        network = "${google_compute_network.default.name}"
        access_config { }
    }
    metadata_startup_script = <<SCRIPT
#!/bin/sh
set -e
echo "Defaults:root !requiretty" >> /etc/sudoers
apt-get update
apt-get install -y ansible git
git clone https://github.com/matsuu/ansible-isucon.git
(
    cd ansible-isucon/isucon4-qualifier-ubuntu
    PYTHONUNBUFFERED=1 ansible-playbook playbook.yml -i local
)
rm -rf ansible-isucon
SCRIPT
}
