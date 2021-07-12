locals {
  subscriptions = {
    for merged_subscription in flatten([
      for name, consumer in var.pull_consumers : [
        for topic, subscription in consumer.subscriptions : {
          queue                        = name
          labels                       = consumer.labels
          service_account              = consumer.service_account
          topic                        = subscription.topic != null ? subscription.topic : topic
          project                      = subscription.project
          enable_ordering              = subscription.enable_ordering
          high_message_count_threshold = subscription.high_message_count_threshold
        }
      ]
    ]) :
    (merged_subscription.project != null ? "${merged_subscription.queue}-${merged_subscription.project}-${merged_subscription.topic}" : "${merged_subscription.queue}-${merged_subscription.topic}") => merged_subscription
  }
}
