resource "aws_acm_certificate" "ssl" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider             = aws.east

}

data "aws_route53_zone" "hosted" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.ssl.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted.zone_id
}

