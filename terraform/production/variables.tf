variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "production_bucket_name" {
  description = "Name of the bucket"
  default     = "banpay.com"
  type        = string
}
