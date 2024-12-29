
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "${var.Project_Name}-${var.account_id}-${var.airport_code[var.region]}-${var.env}-SF"
  role_arn = var.SF_role_arn

  definition = file("${path.module}/code/definition.json")
}
