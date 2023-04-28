
module "staging_template_files" {
  source   = "hashicorp/dir/template"
  base_dir = abspath("${path.module}/../../dist")
}

resource "aws_s3_bucket" "staging_hosting_bucket" {
  bucket = var.staging_bucket_name
}

data "aws_iam_policy_document" "staging_website_policy" {
  statement {

    actions = [
      "s3:*",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::${var.staging_bucket_name}",
      "arn:aws:s3:::${var.staging_bucket_name}/*"
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "staging_bucket" {
  bucket = aws_s3_bucket.staging_hosting_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "staging_bucket" {
  bucket = aws_s3_bucket.staging_hosting_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "staging_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.staging_bucket,
    aws_s3_bucket_public_access_block.staging_bucket
  ]

  bucket = aws_s3_bucket.staging_hosting_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "staging_hosting_bucket_website_configuration" {
  depends_on = [
    aws_s3_bucket.staging_hosting_bucket
  ]

  bucket = aws_s3_bucket.staging_hosting_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "staging_bucket_cors" {
  depends_on = [
    aws_s3_bucket.staging_hosting_bucket
  ]

  bucket = aws_s3_bucket.staging_hosting_bucket.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = [aws_s3_bucket_website_configuration.staging_hosting_bucket_website_configuration.website_endpoint]
    max_age_seconds = 3000
  }
}

resource "aws_s3_object" "staging_hosting_bucket_files" {
  depends_on = [
    aws_s3_bucket.staging_hosting_bucket
  ]

  bucket = aws_s3_bucket.staging_hosting_bucket.id

  for_each     = module.staging_template_files.files
  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  content      = each.value.content
  etag         = each.value.digests.md5
}
