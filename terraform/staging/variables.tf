variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}
variable "AWS_DEFAULT_REGION" {
  description = "AWS default Region"
  default     = "us-east-1"
  type        = string
}
variable "access_key" {
  description = "AWS access_key"
  type        = string
}
variable "secret_key" {
  description = "AWS secret_key"
  type        = string
}
variable "staging_bucket_name" {
  description = "Name of the bucket"
  default     = "myaliasname.banpay.com"
  type        = string
}
