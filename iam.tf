/* 
Lambda stop IAM 
*/
data "aws_iam_policy_document" "lambda_stop_aurora_policy" {
  statement {
    actions = [
      "rds:StopDBCluster",
      "rds:StopDBInstance",
    ]

    resources = [
      "arn:aws:rds:*:*:cluster:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${var.stop_tag_name}"
      values = [
        "${var.stop_tag_value}"
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

module "lambda_stop_aurora_role" {
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.3.0"
  name                  = "lambda_stop_aurora_role-${random_string.random.id}"
  create_policy         = true
  postfix               = false
  principal_type        = "Service"
  principal_identifiers = ["lambda.amazonaws.com"]
  role_policy           = data.aws_iam_policy_document.lambda_stop_aurora_policy.json
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_stop_aurora_policy_vpcaccess" {
  role       = module.lambda_stop_aurora_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_stop_aurora_policy_basic" {
  role       = module.lambda_stop_aurora_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

/* 
Lambda start IAM 
*/
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
  name                  = "lambda_start_aurora_role-${random_string.random.id}"
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