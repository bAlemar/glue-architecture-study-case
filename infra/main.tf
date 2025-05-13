module "s3" {
    source = "./s3"    
    bucket_name = "glue-architecture-terraform"  
}

module "step_function" {
    source = "./step_functions"
}

module "eventbridge" {
    source = "./eventbridge"
    s3_bucket_arn = module.s3.bucket_arn
    bucket_name = module.s3.bucket_name
    step_functions_arn = module.step_function.step_function_arn
}

module "glues"{
    source = "./glue"
    project_name = "glue-architecture-terraform"
}