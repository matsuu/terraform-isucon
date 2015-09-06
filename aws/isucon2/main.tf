# Specify the provider and access details
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.tag_name}"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
    tags = {
        Name = "${var.tag_name}"
    }
}

resource "aws_route_table" "default" {
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
    tags = {
        Name = "${var.tag_name}"
    }
}

resource "aws_route_table_association" "default" {
    subnet_id = "${aws_subnet.default.id}"
    route_table_id = "${aws_route_table.default.id}"
}

resource "aws_subnet" "default" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.subnet_cidr_block}"
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.tag_name}"
    }
}

resource "aws_key_pair" "default" {
    key_name = "${var.tag_name}"
    public_key = "${file(var.ssh_public_key)}"
}

resource "aws_security_group" "default" {
    name = "${var.tag_name}"
    description = "Used in the terraform"
    vpc_id = "${aws_vpc.default.id}"
    tags = {
        Name = "${var.tag_name}"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.access_cidr_blocks}", "${aws_subnet.default.cidr_block}"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.access_cidr_blocks}", "${aws_subnet.default.cidr_block}"]
    }

    # outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web" {
    instance_type = "${var.web_instance_type}"
    ami = "${var.web_ami}"
    key_name = "${aws_key_pair.default.key_name}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    subnet_id = "${aws_subnet.default.id}"
    tags = {
        Name = "${var.tag_name}"
    }
}
