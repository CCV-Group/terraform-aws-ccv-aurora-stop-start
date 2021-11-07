resource "aws_security_group" "rds_lambda" {
  name        = "rds_lambda_sg"
  description = "RDS Lambda Security Group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "rds_lambda_egress_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow Egress traffic over port 443 to each AWS API."
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  security_group_id = aws_security_group.rds_lambda.id
}