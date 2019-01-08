resource "aws_lambda_function" "ehr_extract_handler" {
  function_name = "${var.environment}-${var.ehr_extract_handler_name}"
  filename = "${path.module}/dummy_ehr_extract_handler.zip"
  handler = "main.handler"
  runtime = "nodejs8.10"
  role = "${aws_iam_role.ehr_extract_handler_role.arn}"
}

#resource "aws_iam_role_policy_attachment" "ehr_extract_handler_role_policy_attachment" {
#  role = "${aws_iam_role.apigw_role.name}"
#  policy_arn = "${aws_iam_policy.apigw_policy.arn}"
#  depends_on = [
#    "aws_iam_policy.ehr_extract_handler_policy",
#    "aws_iam_role.ehr_extract_handler_role"
#  ]
#}

data "template_file" "ehr_extract_handler_role" {
  template = "${file("${path.module}/iam_role_lambda.json")}"
}

data "template_file" "ehr_extract_handler_policy" {
  template = "${file("${path.module}/iam_role_policy_lambda.json")}"
}

resource "aws_iam_role_policy" "ehr_extract_handler_policy" {
  name_prefix = "${var.environment}-${var.ehr_extract_handler_name}-"
  policy = "${data.template_file.ehr_extract_handler_policy.rendered}"
  role = "${aws_iam_role.ehr_extract_handler_role.id}"
}

resource "aws_iam_role" "ehr_extract_handler_role" {
  name_prefix = "${var.environment}-${var.ehr_extract_handler_name}-"
  assume_role_policy = "${data.template_file.ehr_extract_handler_role.rendered}"
}
