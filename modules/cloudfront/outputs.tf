output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cf-dist.domain_name
}

output "id" {
  value = aws_cloudfront_distribution.cf-dist.hosted_zone_id
}

