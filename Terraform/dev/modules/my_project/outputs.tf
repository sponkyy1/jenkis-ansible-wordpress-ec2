output "web_server_public_ip" {
  value = aws_instance.my_frontserver.public_ip
}
output "dns_name" {
  value = aws_elb.web_elb.dns_name
}
