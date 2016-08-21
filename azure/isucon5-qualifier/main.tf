resource "azurerm_resource_group" "default" {
    name = "${var.name}"
    location = "${var.location}"
}

resource "azurerm_virtual_network" "default" {
    name = "${var.name}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    address_space = ["${var.cidr_block}"]
    location = "${var.location}"
}

resource "azurerm_subnet" "default" {
    name = "${var.name}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    virtual_network_name = "${azurerm_virtual_network.default.name}"
    address_prefix = "${cidrsubnet(var.cidr_block, 8, 1)}"
}

resource "azurerm_public_ip" "default" {
    count = "${length(var.types)}"
    name = "${var.name}-${var.types[count.index]}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_security_group" "default" {
    name = "${var.name}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.default.name}"
}

resource "azurerm_network_security_rule" "default-ssh" {
    name = "${var.name}-ssh"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "${var.access_cidr_blocks}"
    destination_address_prefix = "VirtualNetwork"
    resource_group_name = "${azurerm_resource_group.default.name}"
    network_security_group_name = "${azurerm_network_security_group.default.name}"
}

resource "azurerm_network_security_rule" "default-http" {
    name = "${var.name}-http"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "${var.access_cidr_blocks}"
    destination_address_prefix = "VirtualNetwork"
    resource_group_name = "${azurerm_resource_group.default.name}"
    network_security_group_name = "${azurerm_network_security_group.default.name}"
}

resource "azurerm_network_interface" "default" {
    count = "${length(var.types)}"
    name = "${var.name}-${var.types[count.index]}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.default.name}"

    ip_configuration {
        name = "${var.name}"
        subnet_id = "${azurerm_subnet.default.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${element(azurerm_public_ip.default.*.id, count.index)}"
    }
}

resource "azurerm_storage_account" "default" {
    name = "${var.name}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    location = "${var.location}"
    account_type = "${var.storage_account_type}"
}

resource "azurerm_storage_container" "default" {
    name = "${var.name}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    storage_account_name = "${azurerm_storage_account.default.name}"
    container_access_type = "private"
}

resource "azurerm_virtual_machine" "bench" {
    name = "${var.name}-${var.types[0]}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    network_interface_ids = ["${element(azurerm_network_interface.default.*.id, 0)}"]
    vm_size = "${var.vm_size[var.types[0]]}"
    delete_os_disk_on_termination = true

    storage_image_reference {
        publisher = "${var.storage_image_reference["publisher"]}"
        offer = "${var.storage_image_reference["offer"]}"
        sku = "${var.storage_image_reference["sku"]}"
        version = "${var.storage_image_reference["version"]}"
    }

    storage_os_disk {
        name = "${var.name}-${var.types[0]}-os"
        vhd_uri = "${azurerm_storage_account.default.primary_blob_endpoint}${azurerm_storage_container.default.name}/${var.types[0]}-os.vhd"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.name}-${var.types[0]}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
        custom_data = "${base64encode(file(format("provision-%s.sh", var.types[0])))}"
    }

    os_profile_linux_config {
        disable_password_authentication = "${var.disable_password_authentication}"
        ssh_keys {
            path = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data = "${file(var.ssh_public_key)}"
        }
    }
}

resource "azurerm_virtual_machine" "image" {
    name = "${var.name}-${var.types[1]}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    network_interface_ids = ["${element(azurerm_network_interface.default.*.id, 1)}"]
    vm_size = "${var.vm_size[var.types[1]]}"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "${var.storage_image_reference["publisher"]}"
        offer = "${var.storage_image_reference["offer"]}"
        sku = "${var.storage_image_reference["sku"]}"
        version = "${var.storage_image_reference["version"]}"
    }

    storage_os_disk {
        name = "${var.name}-${var.types[1]}-os"
        vhd_uri = "${azurerm_storage_account.default.primary_blob_endpoint}${azurerm_storage_container.default.name}/${var.types[1]}-os.vhd"
        create_option = "FromImage"
    }

    storage_data_disk {
        name = "${var.name}-${var.types[1]}-data1"
        vhd_uri = "${azurerm_storage_account.default.primary_blob_endpoint}${azurerm_storage_container.default.name}/${var.types[1]}-data1.vhd"
        create_option = "Empty"
        disk_size_gb = "${var.data_disk_size}"
        lun = 0
    }

    storage_data_disk {
        name = "${var.name}-${var.types[1]}-data2"
        vhd_uri = "${azurerm_storage_account.default.primary_blob_endpoint}${azurerm_storage_container.default.name}/${var.types[1]}-data2.vhd"
        create_option = "Empty"
        disk_size_gb = "${var.data_disk_size}"
        lun = 1
    }

    storage_data_disk {
        name = "${var.name}-${var.types[1]}-data3"
        vhd_uri = "${azurerm_storage_account.default.primary_blob_endpoint}${azurerm_storage_container.default.name}/${var.types[1]}-data3.vhd"
        create_option = "Empty"
        disk_size_gb = "${var.data_disk_size}"
        lun = 2
    }
    storage_data_disk {
        name = "${var.name}-${var.types[1]}-data4"
        vhd_uri = "${azurerm_storage_account.default.primary_blob_endpoint}${azurerm_storage_container.default.name}/${var.types[1]}-data4.vhd"
        create_option = "Empty"
        disk_size_gb = "${var.data_disk_size}"
        lun = 3
    }

    os_profile {
        computer_name = "${var.name}-${var.types[1]}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
        custom_data = "${base64encode(file(format("provision-%s.sh", var.types[1])))}"
    }

    os_profile_linux_config {
        disable_password_authentication = "${var.disable_password_authentication}"
        ssh_keys {
            path = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data = "${file(var.ssh_public_key)}"
        }
    }
}
