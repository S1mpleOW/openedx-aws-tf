resource "aws_s3_bucket" "openedx_lms" {
  bucket = "openedx-lms-${var.stage_name}"
  tags = var.default_tags
}

resource "aws_cloudfront_origin_access_identity" "openedx_lms_oai" {
  comment = "OAI for LMS bucket"
}

resource "aws_cloudfront_distribution" "openedx_lms" {
  enabled = true
  origin {
    domain_name = aws_s3_bucket.openedx_lms.bucket_domain_name
    origin_id   = local.s3_origin_lms_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.openedx_lms_oai.cloudfront_access_identity_path
    }
  }
  is_ipv6_enabled     = false
  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.s3_origin_lms_id
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = "4a439cde-6ee0-4329-9889-e53b41d94a00"
    origin_request_policy_id = "ab0478ac-7ee4-4735-b88b-02772a34a5bd"
    compress                 = true
  }
  price_class = "PriceClass_200"
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

}

data "aws_iam_policy_document" "openedx_lms" {
  statement {
    principals {
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.openedx_lms_oai.id}"]
      type        = "AWS"
    }
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    resources = [
      aws_s3_bucket.openedx_lms.arn,
      "${aws_s3_bucket.openedx_lms.arn}/*"
    ]
    effect = "Allow"
  }

  statement {
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.openedx_lms_oai.id}"]
      type        = "AWS"
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.openedx_lms.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "openedx_lms" {
  bucket = aws_s3_bucket.openedx_lms.id
  policy = data.aws_iam_policy_document.openedx_lms.json
}

resource "aws_s3_bucket_ownership_controls" "openedx_lms" {
  bucket = aws_s3_bucket.openedx_lms.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
