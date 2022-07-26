module "alerts" {
  for_each = var.enable_alerts ? var.pull_consumers : {}

  source  = "cloudchacho/hedwig-alerts/google"
  version = ">= 3.1, <4"

  queue = each.key

  labels = each.value.labels

  alerting_project                               = var.alerting_project
  queue_alarm_high_message_count_threshold       = each.value.high_message_count_threshold
  queue_high_message_count_notification_channels = each.value.queue_alert_notification_channels == null ? var.queue_alert_notification_channels : each.value.queue_alert_notification_channels
  queue_no_activity_notification_channels        = each.value.queue_no_activity_notification_channels == null ? var.queue_no_activity_notification_channels : each.value.queue_no_activity_notification_channels
  dlq_high_message_count_notification_channels   = each.value.dlq_alert_notification_channels == null ? var.dlq_alert_notification_channels : each.value.dlq_alert_notification_channels
}
