locals {
  subscriptions = {
    for merged_subscription in flatten([
      for name, consumer in var.pull_consumers : [
        for topic, subscription in consumer.subscriptions : {
          key = "${name}-${topic}"
          value = merge(subscription, {
            queue           = name
            labels          = consumer.labels
            service_account = consumer.service_account
            topic           = subscription.topic != null ? subscription.topic : topic
          })
        }
      ]
    ]) :
    merged_subscription.key => merged_subscription.value
  }
}
