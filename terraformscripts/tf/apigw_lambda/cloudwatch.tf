resource "aws_cloudwatch_metric_alarm" "prm-gateway-error-4xx" {
  alarm_name                = "prm-gateway-error-4xx"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "4XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "0"
  alarm_description         = "This metric monitors 4xx errors on API-gateway"
  insufficient_data_actions = []

  dimensions {
    ApiName = "${var.api_gateway_endpoint_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "prm-gateway-error-5xx" {
  alarm_name                = "prm-gateway-error-5xx"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "5XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "0"
  alarm_description         = "This metric monitors 5xx errors on API-gateway"
  insufficient_data_actions = []

  dimensions {
    ApiName = "${var.api_gateway_endpoint_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "prm-lambda-ehr_extract_handler-error" {
  alarm_name                = "prm-lambda-ehr_extract_handler-error"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "0"
  alarm_description         = "This metric monitors errors on ehr_extract_handler lambda"
  insufficient_data_actions = []

  dimensions {
    FunctionName = "${module.apigw_lambda_ehr_extract_handler.lambda_function_name}"
    Resource     = "${module.apigw_lambda_ehr_extract_handler.lambda_function_name}"
  }
}

resource "aws_cloudwatch_event_rule" "every_min_rule" {
  name                = "every-minute"
  description         = "Fires every minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "every_minute_event_target" {
  rule = "${aws_cloudwatch_event_rule.every_min_rule.name}"
  arn  = "${module.apigw_lambda_uptime_monitoring.lambda_function_arn}"
}

resource "aws_iam_role" "cloudwatch-apigateway-log-role" {
  name = "cloudwatch-apigateway-log-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch-apigateway-log-policy" {
  role = "${aws_iam_role.cloudwatch-apigateway-log-role.name}"
  name = "cloudwatch-apigateway-log-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:GetLogEvents",
        "logs:FilterLogEvents"
      ]
    }
  ]
}
POLICY
}
