locals {
  projectName="$$Project_Name$$"
  env = "$$env$$"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "StepFunction" {
  source                                    = "../modules/StepFunction"
  Project_Name                              = local.projectName
  SF_role_arn                               = "$$SF_role_arn$$"
  SF_log_destination_arn                    = "$$SF_log_destination_arn$$"
  region                                    = "${data.aws_region.current.name}"
  env                                       = local.env
  airport_code                              = var.AIRPORT_CODE
  account_id                                = "${data.aws_caller_identity.current.id}"
}

module "sf_cloudwatch" {
    source                                  = "../modules/cloudwatch"
    StepFunction_ARN                        = module.StepFunction.Step_Function_Arn
    SCHEDULE_EXPRESSION                     = "$$SCHEDULE_EXPRESSION$$"
    role_arn                                = "$$role_arn$$"
    projectName                             = local.projectName
    region                                  = "${data.aws_region.current.name}"
    env                                     = local.env
    airport_code                            = var.AIRPORT_CODE
    account_id                              = "${data.aws_caller_identity.current.id}"
}

