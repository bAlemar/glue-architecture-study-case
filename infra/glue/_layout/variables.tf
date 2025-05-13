variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "stage" {
  description = "Estágio do Glue Job (ex: bronze, silver, gold)"
  type        = string
}

variable "pythonfile" {
  description = "Nome do arquivo Python para o Glue Job"
  type        = string
}

variable "glue_src_path" {
  description = "Caminho local dos scripts do Glue"
  type        = string
}

variable "role_arn" {
  description = "ARN da Role com permissões para o Glue Job"
  type        = string
}

variable "glue_job_type" {
  description = "Tipo do Glue Job (spark ou pythonshell)"
  type        = string
}

variable "max_capacity" {
  description = "Capacidade máxima (DPU) para o Glue Job"
  type        = number
}

variable "timeout" {
  description = "Tempo limite do Glue Job em minutos"
  type        = number
}

variable "max_retries" {
  description = "Número máximo de tentativas de execução do Glue Job"
  type        = number
}

variable "glue_job_arguments" {
  description = "Argumentos adicionais do Glue Job"
  type        = map(string)
}

variable "bucket_name" {
  description = "Nome do bucket"
  type        = string
  
}