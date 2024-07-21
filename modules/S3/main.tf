resource "aws_s3_bucket" "openedx_fastai_bucket" {
  bucket = "openedx-fastai-${var.stage_name}"
  tags = var.default_tags
}

resource "aws_s3_bucket_public_access_block" "openedx_fastai_bucket_public_access_block" {
  bucket = aws_s3_bucket.openedx_fastai_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_cors_configuration" "openedx_fastai_bucket_cors" {
  bucket = aws_s3_bucket.openedx_fastai_bucket.bucket
  cors_rule {
    allowed_headers = [ "Content-disposition", "Content-type", "X-CSRFToken"]
    allowed_methods = ["GET", "PUT"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "openedx_fastai_profile_images_bucket" {
  bucket = "openedx-fastai-profile-images-${var.stage_name}"
}

resource "aws_s3_bucket_public_access_block" "openedx_fastai_profile_images_bucket_public_access_block" {
  bucket = aws_s3_bucket.openedx_fastai_profile_images_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_cors_configuration" "openedx_fastai_profile_images_bucket_cors" {
  bucket = aws_s3_bucket.openedx_fastai_profile_images_bucket.bucket
  cors_rule {
    allowed_headers = [ "Content-disposition", "Content-type", "X-CSRFToken"]
    allowed_methods = ["GET", "PUT"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

data "aws_iam_policy_document" "openedx_fastai_profile_images_bucket_permission" {
  statement {
    sid = "openedxWebAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject*"]
    resources = [
      aws_s3_bucket.openedx_fastai_profile_images_bucket.arn,
      "${aws_s3_bucket.openedx_fastai_profile_images_bucket.arn}/*"
    ]
  }

  statement {
    sid = "openedxBackendAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.iam_s3_arn]
    }
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.openedx_fastai_profile_images_bucket.arn,
      "${aws_s3_bucket.openedx_fastai_profile_images_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "openedx_fastai_profile_images_bucket_policy" {
  bucket = aws_s3_bucket.openedx_fastai_profile_images_bucket.id
  policy = data.aws_iam_policy_document.openedx_fastai_profile_images_bucket_permission.json
}
