variable "region" {
  default = "ap-south-1"
}

variable "mime_types" {
  type = map(any)
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

locals {
  domain_name = "http://(aws_s3_bucket_website_configuration.static.website_endpoint)"

}


variable "domain_name" {
  default = "blog.chrisich.fun"
}

variable "hosted_zone" {
  default = "chrisich.fun"
}