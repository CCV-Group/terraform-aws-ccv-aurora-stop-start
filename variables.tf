variable "region" {
  type        = string
  description = "Region to deploy Lambda"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to deploy Lambda in"
}

variable "start_cron" {
  type        = string
  default     = "cron(30 8 ? * * *)"
  description = "Cron expression to schedule the cloudwatch event to run the start lambda"
}

variable "start_tag_name" {
  type        = string
  default     = "start_cluster"
  description = "Name of the tag to attach to the Aurora cluster to include in auto start"
}

variable "start_tag_value" {
  type        = string
  default     = "daily"
  description = "Value of the tag to attach to the Aurora cluster to include in auto start"
}

variable "stop_cron" {
  type        = string
  default     = "cron(30 17 ? * * *)"
  description = "Cron expression to schedule the cloudwatch event to run the stop lambda"
}

variable "stop_tag_name" {
  type        = string
  default     = "stop_cluster"
  description = "Name of the tag to attach to the Aurora cluster to include in auto stop"
}

variable "stop_tag_value" {
  type        = string
  default     = "daily"
  description = "Value of the tag to attach to the Aurora cluster to include in auto stop"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to lambda"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy lambda"
}
