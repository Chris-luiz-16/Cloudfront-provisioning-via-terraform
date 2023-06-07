output "bucket_url" {
  value = "http://${aws_s3_bucket_website_configuration.static.website_endpoint}"
}

output "Cloudfron_url" {
value = "http://${var.domain_name}"
}
