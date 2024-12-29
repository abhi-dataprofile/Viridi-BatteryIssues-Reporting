variable "Project_Name" {
  description = "Project_Name"
}

variable "SF_role_arn" {
  description ="SF_role_arn"
}

variable "SF_log_destination_arn" {
  description ="SF_log_destination_arn"
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
