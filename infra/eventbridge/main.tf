resource "aws_cloudwatch_event_rule" "s3_event_rule" {
  name        = "eventbridge-s3-rule"
  description = "Dispara quando novo objeto é criado no bucket"
  event_pattern = jsonencode({
    source      = ["aws.s3"],
    detail-type = ["Object Created"],
    resources   = ["${var.s3_bucket_arn}"],
  })
}

resource "aws_cloudwatch_event_target" "s3_to_stepfunction" {
  rule      = aws_cloudwatch_event_rule.s3_event_rule.name
  target_id = "StepFunctionTarget"
  arn       = var.step_functions_arn
  role_arn  = aws_iam_role.eventbridge_invoke_sfn.arn

  input_transformer {
    input_paths = {
      bucketName = "$.detail.bucket.name"
      objectKey  = "$.detail.object.key"
    }

    input_template = <<EOF
{
  "ingest_id": "${formatdate("YYYYMMDD", timestamp())}",
  "bucket": <bucketName>,
  "object_key": <objectKey>
}
EOF
  }
}


### IAM => ROLES ANS POLICYS
resource "aws_iam_role" "eventbridge_invoke_sfn" {
  name = "eventbridge-invoke-sfn"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_invoke_sfn_policy" {
  name = "invoke-sfn-policy"
  role = aws_iam_role.eventbridge_invoke_sfn.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "states:StartExecution",
      Resource = ["${var.step_functions_arn}"]
    }]
  })
}
