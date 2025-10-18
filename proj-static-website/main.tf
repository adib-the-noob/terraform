terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
  backend "s3" {
    bucket = "adib-bucket-da780050d2c52f28"
    key    = "backend.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "rand_id" {
  byte_length = 8
}

output "name" {
  value = random_id.rand_id.hex
}

resource "aws_s3_bucket" "my-webapp-bucket" {
  bucket = "adib-bucket-${random_id.rand_id.hex}"
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.my-webapp-bucket.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.my-webapp-bucket.bucket
  source       = "./style.css"
  key          = "style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "script_js" {
  bucket       = aws_s3_bucket.my-webapp-bucket.bucket
  source       = "./script.js"
  key          = "script.js"
  content_type = "text/javascript"
}

resource "aws_s3_bucket_public_access_block" "my-webapp-bucket-public-access" {
  bucket                  = aws_s3_bucket.my-webapp-bucket.bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "my-webapp-bucket-policy" {
  bucket = aws_s3_bucket.my-webapp-bucket.bucket
  depends_on = [ aws_s3_bucket_public_access_block.my-webapp-bucket-public-access ]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.my-webapp-bucket.bucket}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "my-webapp-bucket-website" {
  bucket = aws_s3_bucket.my-webapp-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
  routing_rule {
    condition {
      key_prefix_equals = ""
    }
    redirect {
      replace_key_prefix_with = "index.html"
    }
  }
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.my-webapp-bucket-website.website_endpoint
}