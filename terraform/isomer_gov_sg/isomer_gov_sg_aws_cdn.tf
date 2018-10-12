# Notes:
# AWS CloudFront CDN for isomer.gov.sg

# AWS S3 Bucket to store CloudFront logs
resource "aws_s3_bucket" "isomer_cdn_logs_isomer_gov_sg" {
  bucket = "isomer-isomer-gov-sg-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "isomer_iam_policy_cdn_logs_isomer_gov_sg" {
  bucket = "${aws_s3_bucket.isomer_cdn_logs_isomer_gov_sg.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
  "Sid": "PublicReadGetObject",
  "Effect": "Allow",
  "Principal": "*",
  "Action": [
    "s3:GetObject",
    "s3:PutObject"
  ],
  "Resource": "arn:aws:s3:::isomer-isomer-gov-sg-logs/*"
    }
  ]
}
POLICY
}

# Resource name convention: isomer_cdn_[url_in_underscore]
# Origin ID convention:     isomer_github_pages_[repo name]
# Logging Bucket:           isomer_[url_in_underscore]_logs
resource "aws_cloudfront_distribution" "isomer_cdn_isomer_gov_sg" {
  origin {
    origin_id   = "isomer_github_pages_isomerpages-isomergovsg"
    domain_name = "isomerpages.github.io"
    origin_path = "/isomerpages-isomergovsg"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["www.isomer.gov.sg", "isomer.gov.sg"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "isomer-isomer-gov-sg"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 86400
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method = "sni-only"
    acm_certificate_arn = "arn:aws:acm:ap-southeast-1:095733531422:certificate/2d0fe1f2-b166-421f-ad64-f94b9e773412"
  }

  logging_config {
    include_cookies = false
    bucket = "${aws_s3_bucket.isomer_cdn_logs_isomer_gov_sg.id}"
  }
}