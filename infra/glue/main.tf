module "raw" {
    source = "./_layout"
    project_name = var.project_name
    stage = "raw"
    glue_src_path = path.module
    pythonfile = "raw.py"
    bucket_name = "glue-architecture-project"
    role_arn = aws_iam_role.glue_service_role.arn
    glue_job_type = "5.0"
    timeout = 60
    max_retries = 2
    max_capacity = 5
    glue_job_arguments = {
        "ingest_id" = ""
        "bucket"    = ""
    }    
}

module "silver"{
    source = "./_layout"
    project_name = var.project_name
    stage = "silver"
    glue_src_path = path.module
    pythonfile = "silver.py"
    bucket_name = "glue-architecture-project"
    role_arn = aws_iam_role.glue_service_role.arn
    glue_job_type = "5.0"
    timeout = 60
    max_retries = 2
    max_capacity = 5
    glue_job_arguments = {
        "ingest_id" = ""
        "bucket"    = ""
    }   
}

module "gold"{
    source = "./_layout"
    project_name = var.project_name
    stage = "gold"
    glue_src_path = path.module
    pythonfile = "gold.py"
    bucket_name = "glue-architecture-project"
    role_arn = aws_iam_role.glue_service_role.arn
    glue_job_type = "5.0"
    timeout = 60
    max_retries = 2
    max_capacity = 5
    glue_job_arguments = {
        "ingest_id" = ""
        "bucket"    = ""
    }   
}

resource "aws_iam_role" "glue_service_role" {
  name = var.project_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "glue_policy" {
  name = "${var.project_name}-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::",
          "arn:aws:s3:::glue-architecture-project/*",          
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "glue:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_glue_policy" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}
