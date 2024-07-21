output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.openedx_lms.domain_name
}
