
provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}


# Bucket creation for cloudfront

resource "aws_s3_bucket" "test" {
  bucket        = "cloudfront-blog-static"
  force_destroy = true
  tags = {
    Name        = "bucket-shopping"
    Environment = "Dev"
  }
}


# Bucket versioning enabled

resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.test.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket policy Creation

data "aws_iam_policy_document" "iam" {

  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      "${aws_s3_bucket.test.arn}",
      "${aws_s3_bucket.test.arn}/*",
    ]
  }
}


#  Block public acess for the bucket

resource "aws_s3_bucket_public_access_block" "false" {
  bucket = aws_s3_bucket.test.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# Bucket Policy attach

resource "aws_s3_bucket_policy" "attach" {
  bucket = aws_s3_bucket.test.id
  policy = data.aws_iam_policy_document.iam.json
}



resource "aws_s3_object" "content" {
  for_each = fileset("${var.path}", "**/*.*")

  bucket       = aws_s3_bucket.test.id
  key          = each.key
  source       = "${var.path}/${each.key}"
  content_type = lookup(var.mime_types, element(split(".", each.key), length(split(".", each.key)) - 1))
  etag         = filemd5("${var.path}/${each.key}")
}


# Enabling static S3 website hosting


resource "aws_s3_bucket_website_configuration" "static" {
  bucket = aws_s3_bucket.test.id

  index_document {
    suffix = "index.html"
  }
}

