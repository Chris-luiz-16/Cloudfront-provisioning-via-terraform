resource "aws_cloudfront_distribution" "static" {
  origin {
    domain_name = aws_s3_bucket.test.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.test.id
  }
  enabled             = true
  default_root_object = "index.html"

  aliases = ["blog.chrisich.fun"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.test.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }


    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.ssl.arn
    ssl_support_method = "sni-only"
  }

depends_on = [aws_route53_record.acm,aws_acm_certificate_validation.check ]
}

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.hosted.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl   = 5
records = [aws_cloudfront_distribution.static.domain_name]
  }

