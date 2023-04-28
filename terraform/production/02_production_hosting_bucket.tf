
module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = abspath("${path.module}/../../dist")
}

resource "aws_s3_bucket" "hosting_bucket" {
  bucket = var.production_bucket_name
}

data "aws_s3_bucket" "selected-bucket" {
  bucket = aws_s3_bucket.hosting_bucket.bucket
}
data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.production_bucket_name}/*"
    ]
  }
}
resource "aws_s3_bucket_acl" "hosting_bucket_acl" {
  bucket = aws_s3_bucket.hosting_bucket.id
  acl    = "public-read"
}
resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = data.aws_s3_bucket.selected-bucket.bucket
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = [aws_s3_bucket_website_configuration.prod_hosting_bucket_website_configuration.website_endpoint]
    max_age_seconds = 3000
  }
}
resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
  bucket = aws_s3_bucket.hosting_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.production_bucket_name}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "prod_hosting_bucket_website_configuration" {
  bucket = aws_s3_bucket.hosting_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "hosting_bucket_files" {
  bucket = aws_s3_bucket.hosting_bucket.id

  for_each     = module.template_files.files
  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  content      = each.value.content
  etag         = each.value.digests.md5
}
