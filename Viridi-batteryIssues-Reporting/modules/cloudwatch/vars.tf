variable "SCHEDULE_EXPRESSION" {
  description = "SCHEDULE_EXPRESSION"
}

variable "StepFunction_ARN" {
  description = "StepFunction ARN"
}

variable "projectName" {
  description = "Project Name"
}
variable "account_id"  {
  description = "Account Id"
}

variable "env" {
  description = "Type of Environment like Prod, Dev, QA"
  default     = "QA"
}

variable "region" {
  description = "region_name"
}

variable "airport_code" {
  type = map(string)
}

variable "role_arn"{
  description = "Role Arn for Cloudwatch Event Rule"
}


