output "step_function_arn" {
    description = "ARN da Step Function"
    value = aws_sfn_state_machine.main.arn
}