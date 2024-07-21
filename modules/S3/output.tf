output "openedx_fastai_bucket_name" {
  value = aws_s3_bucket.openedx_fastai_bucket.bucket
}

output "openedx_fastai_profile_images_bucket_name" {
  value = aws_s3_bucket.openedx_fastai_profile_images_bucket.bucket
}
