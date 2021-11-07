data "archive_file" "lambda_start_aurora" {
  type        = "zip"
  source_file = "${path.module}/lambda/start_aurora.py"
  output_path = "${path.module}/lambda/start_aurora.zip"
}

module "lambda_start_aurora" {
  source        = "github.com/schubergphilis/terraform-aws-mcaf-lambda?ref=v0.1.25"
  name          = "lambda_start_aurora"
  create_policy = false
  description   = "Start list of aurora databases by tag"
  filename      = data.archive_file.lambda_start_aurora.output_path
  handler       = "start_aurora.lambda_handler"
  role_arn      = module.lambda_start_aurora_role.arn
  runtime       = "python3.8"
  subnet_ids    = var.subnet_ids
  timeout       = 60
  tags          = var.tags

  providers = {
    aws.lambda = aws
  }

  environment = {
    "REGION" = "${var.region}"
    "KEY"    = "${var.start_tag_name}"
    "VALUE"  = "${var.start_tag_value}"
  }
}

data "aws_iam_policy_document" "lambda_start_aurora_policy" {
  statement {
    actions = [
      "rds:StartDBCluster",
      "rds:StartDBInstance",
    ]

    resources = [
      "arn:aws:rds:*:*:cluster:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${var.start_tag_name}"
      values = [
        "${var.start_tag_value}"
      ]
    }
  }

  statement {
    actions = [
      "rds:DescribeDBClusters",
      "rds:ListTagsForResource",
    ]

    resources = [
      "arn:aws:rds:*:*:cluster:*"
    ]
  }
}

module "lambda_start_aurora_role" {
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.3.0"
  name                  = "lambda_start_aurora_role"
  create_policy         = true
  postfix               = false
  principal_type        = "Service"
  principal_identifiers = ["lambda.amazonaws.com"]
  role_policy           = data.aws_iam_policy_document.lambda_start_aurora_policy.json
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_start_aurora_policy_vpcaccess" {
  role       = module.lambda_start_aurora_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_start_aurora_policy_basic" {
  role       = module.lambda_start_aurora_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "lambda_start_aurora_cloudwatch" {
  statement_id  = "lambda_start_aurora_cloudwatch_permission"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_start_aurora.name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_start_aurora.arn
}

resource "aws_cloudwatch_event_rule" "lambda_start_aurora" {
  description         = "Event to schedule daily start of Aurora databases"
  name                = "start_aurora"
  schedule_expression = var.start_cron
}

resource "aws_cloudwatch_event_target" "lambda_start_aurora" {
  rule = aws_cloudwatch_event_rule.lambda_start_aurora.name
  arn  = module.lambda_start_aurora.arn
}