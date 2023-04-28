output "staging_website_url" {
  description = "Staging URL of the website"
  value       = "http://${aws_s3_bucket_website_configuration.staging_hosting_bucket_website_configuration.website_endpoint}"
}
