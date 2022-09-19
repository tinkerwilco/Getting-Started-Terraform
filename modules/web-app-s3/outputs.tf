## Bucket object
output "bucket_object" {
  value = aws_s3_bucket.web_bucket
}

## Instance profile object
output "instance_profile_object" {
  value = aws_iam_instance_profile.nginx_profile
}