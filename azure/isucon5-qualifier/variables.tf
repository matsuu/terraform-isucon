variable "admin_username" {
    default = "isucon" # CHANGEME
}

# admin_password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following:
# 1. Contains an uppercase character
# 2. Contains a lowercase character
# 3. Contains a numeric digit
# 4. Contains a special character
variable "admin_password" {
    default = "Isucon5!" # CHANGEME
}

variable "disable_password_authentication" {
    default = true
}

variable "ssh_public_key" {
    description = "ssh public key"
    default = "~/.ssh/id_rsa.pub" # CHANGEME
}

# https://azure.microsoft.com/en-us/regions/
variable "location" {
    default = "Japan East"
#   default = "Japan West"
}

variable "access_cidr_blocks" {
    description = "IPaddress to access SSH and HTTP"
    default = "0.0.0.0/0"
}

variable "name" {
    default = "isucon5qualifier"
}

variable "types" {
    default = ["bench", "image"]
}

variable "cidr_block" {
    default = "10.5.0.0/16"
}

variable "storage_account_type" {
    default = "Standard_LRS"
#   default = "Standard_ZRS"
#   default = "Standard_GRS"
#   default = "Standard_RAGRS"
#   default = "Premium_LRS"
}

variable "vm_size" {
    default = {
        bench = "Basic_A2"
#       image = "Basic_A2"
#       image = "Basic_A3"
        image = "Standard_A2"
#       image = "Standard_A3"
    }
}

variable "storage_image_reference" {
    default = {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04.0-LTS"
        version = "latest"
    }
}

variable "data_disk_size" {
    default = "2"
}
