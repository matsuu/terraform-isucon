output "bench_private_ip" {
    value = "${azurerm_public_ip.default.0.private_ip_address}"
}

output "bench_ssh" {
    value = "ssh ${var.admin_username}@${azurerm_public_ip.default.0.ip_address}"
}

output "run benchmark" {
    value = "ssh ${var.admin_username}@${azurerm_public_ip.default.0.ip_address} ./bench.sh ${azurerm_public_ip.default.1.private_ip_address}"
}

output "image_private_ip" {
    value = "${azurerm_public_ip.default.1.private_ip_address}"
}

output "image_ssh" {
    value = "ssh ${var.admin_username}@${azurerm_public_ip.default.1.ip_address}"
}
