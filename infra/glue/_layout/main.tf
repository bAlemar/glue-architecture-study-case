# main.tf no módulo glue-job-stages
resource "aws_s3_object" "deploy_script" {
  bucket = var.bucket_name  # Refere-se ao bucket criado acima
  key    = "scripts/${var.stage}/${var.pythonfile}"  # Organiza o arquivo dentro de uma pasta com o nome do estágio
  source = "${var.glue_src_path}/scripts/${var.pythonfile}"  # Caminho local do script para fazer o upload
  etag   = filemd5("${var.glue_src_path}/scripts/${var.pythonfile}")  # Detecta alterações no script
}

resource "aws_glue_job" "etl_job" {
  name     = "${var.project_name}-${var.stage}"  # Nome do Glue Job incluindo o estágio
  role_arn = var.role_arn  # ARN da role IAM com permissões para o Glue

  command {
    name            = "glueetl"
    script_location = "s3://${var.bucket_name}/${aws_s3_object.deploy_script.key}"  # Caminho do script no S3
    python_version  = "3"
  }

  timeout          = var.timeout       # Timeout em minutos
  max_retries      = var.max_retries   # Número máximo de tentativas
  glue_version     = var.glue_job_type
  execution_class  = "FLEX"
  worker_type      = "G.1X"
  number_of_workers = 5
  
default_arguments = merge(
  {
    "--job-language"                         = "python"
    "--enable-continuous-cloudwatch-log"     = "true"
    "--enable-metrics"                       = "true"           # Ativa métricas para CloudWatch
    "--enable-spark-ui"                      = "true"           # Ativa Spark UI para jobs Glue >= 2.0
    "--spark-event-logs-path"                = "s3://${var.bucket_name}/spark-ui/${var.project_name}-${var.stage}"  # Onde armazenar os logs da Spark UI
    "--TempDir"                              = "s3://${var.bucket_name}/spark-temp/${var.project_name}-${var.stage}"      # Diretório temporário da execução
    "--enable-glue-datacatalog"              = "true"           # Usa o Glue Data Catalog
  },
  var.glue_job_arguments  # Aqui você pode passar ingest_id, bucket, etc
)

  tags = {
    Environment = "Development"
    Project     = "${var.project_name} Glue Job"
    Stage       = var.stage
  }
}
