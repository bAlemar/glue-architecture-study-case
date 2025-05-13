resource "aws_sfn_state_machine" "main" {
  name     = "my-stepfunction"
  role_arn = aws_iam_role.stepfunction_role.arn
  definition = file("${path.module}/state-machine-definition.json")
}


resource "aws_iam_role" "stepfunction_role" {
  name = "stepfunction-basic-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "stepfunction_basic_policy" {
  name = "basic-policy"
  role = aws_iam_role.stepfunction_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogDelivery",
        "logs:GetLogDelivery",
        "logs:UpdateLogDelivery",
        "logs:DeleteLogDelivery",
        "logs:ListLogDeliveries",
        "logs:PutResourcePolicy",
        "logs:DescribeResourcePolicies",
        "logs:DescribeLogGroups"
      ]
      Resource = "*"
    },
    {
        Effect = "Allow",
        Action = [
          "glue:StartJobRun",
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:GetJob"
        ],
        Resource = "*"
      },]
  })
}
