module "alerts" {
  for_each = var.enable_alerts ? var.pull_consumers : {}

  source  = "cloudchacho/hedwig-alerts/google"
  version = ">= 2, <3"

  subscription_name                        = module.queues[each.key].subscription_name
  dlq_subscription_name                    = module.queues[each.key].dlq_subscription_name
  queue_alarm_high_message_count_threshold = each.value.high_message_count_threshold

  labels = each.value.labels

  alerting_project                               = var.alerting_project
  queue_high_message_count_notification_channels = each.value.queue_alert_notification_channels == null ? var.queue_alert_notification_channels : each.value.queue_alert_notification_channels
  dlq_high_message_count_notification_channels   = each.value.dlq_alert_notification_channels == null ? var.dlq_alert_notification_channels : each.value.dlq_alert_notification_channels
}

module "alerts-subscriptions" {
  for_each = var.enable_alerts ? local.subscriptions : {}

  source  = "cloudchacho/hedwig-alerts/google"
  version = ">= 2, <3"

  subscription_name                        = module.subscriptions[each.key].subscription_name
  queue_alarm_high_message_count_threshold = each.value.high_message_count_threshold

  labels = each.value.labels

  alerting_project                               = var.alerting_project
  queue_high_message_count_notification_channels = each.value.queue_alert_notification_channels
  dlq_high_message_count_notification_channels   = each.value.dlq_alert_notification_channels
}
