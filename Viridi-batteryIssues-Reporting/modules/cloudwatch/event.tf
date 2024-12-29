## AT&T Ctdi Event
resource "aws_cloudwatch_event_rule" "scheduling-event" {
  name                = "${var.projectName}-${var.account_id}-${var.airport_code[var.region]}-${var.env}-event-rule"
  description         = "Triggering Step Function"
  schedule_expression = var.SCHEDULE_EXPRESSION
  role_arn            = var.role_arn
  is_enabled          = true
  tags = {
      purpose = "To trigger Step Function"
      owner   = "divyansh.saxena@viridi.com"
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.projectName}-${var.account_id}-${var.airport_code[var.region]}-${var.env}-cloudwatch-log-group"
  retention_in_days = 0
}
