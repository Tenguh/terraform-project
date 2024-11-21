output "ec2_public_ip-_1" {
  value = module.myapp-server.instance.public_ip
  description = "The public ip of myapp-server-1"
}

output "ec2_public_ip_2" {
  value = module.myapp-server-2.instance.public_ip
  description = "The public ip of myapp-server-2"
}



