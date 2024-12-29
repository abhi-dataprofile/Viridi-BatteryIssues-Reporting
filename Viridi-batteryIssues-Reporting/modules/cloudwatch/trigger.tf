resource "aws_cloudwatch_event_target" "sf_scheduled_task" {
  arn       = var.StepFunction_ARN
  rule      = aws_cloudwatch_event_rule.scheduling-event.name
  role_arn  = var.role_arn
  target_id = "stepfunction"
}
