variable "region" {
description = "Default region where your s3 bucket get's created in my case I've choosen ap-south-1/Mumbai"
  default = "ap-south-1"
}

variable "aws_secret_key" {
  description = "Secret key of IAM User"
  type        = string
  default     = "<Secret Key>"
}
variable "aws_access_key" {
  description = "Access key of the IAM user"
  type        = string
  default     = "Access_key"
}

variable "mime_types" {
  description= "This is to set mime_types for your static website."
  type = map
  default = {
    "css"   = "text/css"
    "html"  = "text/html"
    "ico"   = "image/vnd.microsoft.icon"
    "js"    = "application/javascript"
    "json"  = "application/json"
    "map"   = "application/json"
    "png"   = "image/png"
    "svg"   = "image/svg+xml"
    "txt"   = "text/plain"
    "woff"  = "application/font-woff"
    "woff2" = "application/font-woff2"
    "jpg"   = "image/jpeg"
  }
}
 
variable "domain_name" {
description = "Domain name that should point to S3 or cloudfront endpoint"
  default = "<name of the domain that needs to point to cloudfront>"
}

variable "hosted_zone" {
descrition = "Hosted_zone name"
  default = "Name of the hosted zone in route53"
}
