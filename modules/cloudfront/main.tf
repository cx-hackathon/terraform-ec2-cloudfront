# data "aws_acm_certificate" "cert" {
#   domain      = var.cert_domain_name
#   statuses = ["ISSUED"]
# }


resource "aws_cloudfront_distribution" "cf-dist" {
  origin {
    domain_name = var.hostname
    origin_id   = var.hostname

    custom_origin_config {
      http_port              = var.http_port
      https_port             = var.https_port
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    origin_shield {
      enabled              = false
      origin_shield_region = "ap-southeast-1"
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = var.description



  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true # Compress Objects Automatically
    target_origin_id = var.hostname

    forwarded_values {
      headers      = ["*"]
      query_string = true
      cookies {
        forward = "all"
      }
    }

    # dev / uat, internal testing = "HTTP and HTTPS" == "allow-all"
    # prod / deliever to client = "Redirect HTTP to HTTPS" == "redirect-to-https"
    viewer_protocol_policy = var.viewer_protocol_policy

    smooth_streaming = false
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  # aliases = var.alternate_domain_names

  tags = {
    Name = var.hostname
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn = data.aws_acm_certificate.cert.arn
    # ssl_support_method  = "sni-only"
  }
}
