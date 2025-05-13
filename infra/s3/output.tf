output "bucket_arn" {
  description = "ARN do bucket S3 externo"
  value       = aws_s3_bucket.external_data_bucket.arn
}

output "bucket_name" {
  description = "Nome do bucket S3 externo"
  value       = aws_s3_bucket.external_data_bucket.id
}
