output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "Name of the bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the bucket."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.this.bucket_domain_name
  description = "Bucket domain name."
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "The bucket region-specific domain name. The bucket domain name including the region name."
}

output "bucket_hosted_zone_id" {
  value       = aws_s3_bucket.this.hosted_zone_id
  description = "Route 53 Hosted Zone ID for this bucket's region."
}

output "bucket_region" {
  value       = aws_s3_bucket.this.region
  description = "AWS region this bucket resides in."
}

output "bucket_tags_all" {
  value       = aws_s3_bucket.this.tags_all
  description = "Map of tags assigned to the resource."
}
