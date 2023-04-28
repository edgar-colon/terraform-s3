output "prod_website_url" {
  description = "Production URL of the website"
  value       = "http://${aws_s3_bucket_website_configuration.prod_hosting_bucket_website_configuration.website_endpoint}"
}

output "prod_local_website_url" {
  description = "Local URL of the website"
  value       = "http://${var.production_bucket_name}.s3.localhost.localstack.cloud:4566/index.html"
}

