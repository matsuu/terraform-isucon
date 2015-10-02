variable "account_file" {
    description = "GOOGLE_ACCOUNT_FILE environment variable"
    default = "account.json"
}

variable "project" {
    description = "GOOGLE_PROJECT environment variable"
    default = "isucon" #CHANGEME
}

# Create your own isucon image manually
# gcloud compute --project "isucon" images create "isucon5q-1" --source-uri https://storage.googleapis.com/isucon5-images/isucon5-qualifier-4.image.tar.gz

variable "image_disk_image" {
    description = "https://github.com/isucon/isucon5-qualify"
    default = "isucon5q-1" #CHANGEME
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

variable "bench_machine_type" {
    description = "gcloud compute machine-types list"
    #default = "f1-micro"
    #default = "g1-small"
    #default = "n1-standard-1"
    #default = "n1-highcpu-2"
    default = "n1-highcpu-4"
}

variable "image_machine_type" {
    description = "gcloud compute machine-types list"
    #default = "f1-micro"
    #default = "g1-small"
    #default = "n1-standard-1"
    #default = "n1-highcpu-2"
    default = "n1-highcpu-4"
}

variable "bench_disk_image" {
    description = "gcloud compute images list"
    default = "ubuntu-1504-vivid-v20150911"
}

variable "name" {
    default = "isucon5-qualifier"
}

variable "ipv4_range" {
    default = "10.0.5.0/24"
}
