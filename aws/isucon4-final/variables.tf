variable "aws_access_key" {
    description = "AWS_ACCESS_KEY_ID"
    default = "AKIA..." # CHANGEME
}

variable "aws_secret_key" {
    description = "AWS_SECRET_ACCESS_KEY"
    default = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" # CHANGEME
}

variable "ssh_public_key" {
    description = "ssh public key"
    default = "~/.ssh/id_rsa.pub" # CHANGEME
}

variable "web_instance_type" {
    default = "c3.large"
}

variable "bench_instance_type" {
    default = "c3.2xlarge"
}

variable "access_cidr_blocks" {
    description = "IPaddress to access SSH and HTTP"
    default = "0.0.0.0/0"
}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "ap-northeast-1"
}

variable "web_ami" {
    default = "ami-86e8e287"
}

variable "bench_ami" {
    default = "ami-84e8e285"
}

variable "tag_name" {
    default = "isucon4-final"
}

variable "vpc_cidr_block" {
    default = "10.104.0.0/16"
}

variable "subnet_cidr_block" {
    default = "10.104.1.0/24"
}

variable "web_count" {
    default = "3"
}
