output "web_address" {
  value = "${join(", ", aws_instance.web.*.public_dns)}"
}
