locals {
  subscriptions = {
    for merged_subscription in flatten([
      for name, consumer in var.pull_consumers : [
        for topic, subscription in consumer.subscriptions : {
          key = "${name}-${topic}"
          value = {
            queue                             = name
            labels                            = consumer.labels
            service_account                   = consumer.service_account
            topic                             = subscription.topic != null ? subscription.topic : topic
            project                           = subscription.project
            enable_ordering                   = subscription.enable_ordering
            high_message_count_threshold      = subscription.high_message_count_threshold
            disable_dlq                       = subscription.disable_dlq == null ? false : subscription.disable_dlq,
            queue_alert_notification_channels = subscription.queue_alert_notification_channels == null ? var.queue_alert_notification_channels : subscription.queue_alert_notification_channels
            dlq_alert_notification_channels   = subscription.dlq_alert_notification_channels == null ? var.dlq_alert_notification_channels : subscription.dlq_alert_notification_channels
          }
        }
      ]
    ]) :
    merged_subscription.key => merged_subscription.value
  }
}
