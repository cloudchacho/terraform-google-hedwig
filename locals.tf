locals {
  subscriptions = {
    for subscription in flatten([
      for name, consumer in var.pull_consumers : [
        for topic, subscription in consumer.subscriptions : merge(subscription, {
          queue  = name
          topic  = topic
          labels = consumer.labels
        })
      ]
    ]) : "${subscription.queue}-${subscription.topic}" => subscription
  }
}
