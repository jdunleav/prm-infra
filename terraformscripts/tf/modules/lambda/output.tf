output "lambda_function_arn" {
  value = "${aws_lambda_function.handler.arn}"
}

output "lambda_function_name" {
  value = "${aws_lambda_function.handler.function_name}"
}