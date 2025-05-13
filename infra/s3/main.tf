resource "aws_s3_bucket" "external_data_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = aws_s3_bucket.external_data_bucket.id
  eventbridge = true
}

resource "aws_s3_bucket_policy" "allow_eventbridge" {
  bucket = aws_s3_bucket.external_data_bucket.id
  policy = data.aws_iam_policy_document.allow_eventbridge.json
}

data "aws_iam_policy_document" "allow_eventbridge" {
  statement {
    actions = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.external_data_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}