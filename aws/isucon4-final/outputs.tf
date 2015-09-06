output "web_address" {
  value = "${join(", ", aws_instance.web.*.public_dns)}"
}

output "bench_address" {
  value = "${aws_instance.bench.public_dns}"
}
