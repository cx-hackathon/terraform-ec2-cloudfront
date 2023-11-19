output "ec2_public_dns" {
  value = module.myapp-server.instance.public_dns
}

output "cloudfront_dns" {
  value = module.myapp-cf.cloudfront_domain_name
}
