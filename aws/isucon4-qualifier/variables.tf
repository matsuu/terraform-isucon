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
    default = "m3.xlarge"
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
    default = "ami-e3577fe2"
}

variable "tag_name" {
    default = "isucon4-qualifier"
}

variable "vpc_cidr_block" {
    default = "10.4.0.0/16"
}

variable "subnet_cidr_block" {
    default = "10.4.1.0/24"
}
