variable "account_file" {
    description = "GOOGLE_ACCOUNT_FILE environment variable"
    default = "account.json"
}

variable "project" {
    description = "GOOGLE_PROJECT environment variable"
    default = "isucon" # CHANGEME
}

variable "zone" {
    description = "gcloud compute zones list"
    default = "asia-east1-a"
    #default = "asia-east1-b"
    #default = "asia-east1-c"
    #default = "us-central1-a"
    #default = "us-central1-b"
    #default = "us-central1-c"
    #default = "us-central1-f"
}

variable "web_machine_type" {
    description = "gcloud compute machine-types list"
#    default = "f1-micro"
    default = "g1-small"
#    default = "n1-standard-1"
}

variable "web_disk_image" {
    description = "gcloud compute images list"
    default = "centos-6-v20150818"
}

variable "web_name" {
    default = "isucon4-qualifier"
}

variable "ipv4_range" {
    default = "10.0.4.0/24"
}
