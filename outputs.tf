output "ec2_public_dns" {
  value = module.myapp-server.instance.public_dns
}
