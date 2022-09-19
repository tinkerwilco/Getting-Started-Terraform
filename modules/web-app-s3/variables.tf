variable "bucket_name" {
  type        = string
  description = "Name of S3 bucket to create"
}

variable "elb_service_account_arn" {
  type        = string
  description = "ARN of ELB svc acct"
}

variable "common_tags" {
  type        = map(string)
  description = "map of tags applied to all resources"
  default = {
    # "key" = "value"
  }
}