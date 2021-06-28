output "web_server_public_ip" {
  value = module.ec2_instance.web_server_public_ip
}
output "dns_name" {
  value = module.ec2_instance.dns_name
}