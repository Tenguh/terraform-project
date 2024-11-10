output "ec2_public_ip-_1" {
  value = module.myapp-server-1.instance.public_ip
}

output "ec2_public_ip_2" {
  value = module.myapp-server-2.instance.public_ip
}

