variable "enable_firehose_all_topics" {
  default     = false
  description = "Enable firehose for all messages on all topics"
}

variable "enable_alerts" {
  default     = false
  description = "Create monitoring alerts in Stackdriver"
}

variable "alerting_project" {
  default     = ""
  description = "The project id to create monitoring alert policies"
}

variable "dlq_alert_notification_channels" {
  default     = []
  type        = list(string)
  description = "List of Stackdriver notification channels for dead-letter queue non-empty alert"
}

variable "queue_alert_notification_channels" {
  default     = []
  type        = list(string)
  description = "List of Stackdriver notification channels for queue high message count alert"
}

variable "pull_consumers" {
  description = "List of pull consumers, map of consumer queue name to queue config"
  default     = {}
  type = map(object({
    # labels associated with this app
    labels = optional(map(string))

    # service account for this app
    service_account = optional(string)

    # list of subscriptions for this consumer
    # the key is the topic name. In case of conflicts in topic name due to cross-project subscriptions,
    # use the field `topic` to override topic name
    subscriptions = map(object({
      # the topic name for subscription
      topic = optional(string)

      # for cross-project subscriptions, set to topic's project id
      project = optional(string)

      # ordered queues (https://cloud.google.com/pubsub/docs/ordering)
      enable_ordering = optional(bool)

      # disable dead letter queues. This is useful for firehose subscription using dataflow. Default false.
      disable_dlq = optional(bool, false)

      # The subscription only delivers the messages that match the filter. Pub/Sub automatically acknowledges the messages that don't match the filter. You can filter messages by their attributes. The maximum length of a filter is 256 bytes. After creating the subscription, you can't modify the filter.
      filter = optional(string)

      # The maximum number of delivery attempts for any message. The value must be between 5 and 100. The number of delivery attempts is defined as 1 + (the sum of number of NACKs and number of times the acknowledgement deadline has been exceeded for the message). A NACK is any call to ModifyAckDeadline with a 0 deadline. Note that client libraries may automatically extend ack_deadlines. This field will be honored on a best effort basis.
      max_delivery_attempts = optional(number)

      # A policy that specifies how Pub/Sub retries message delivery for this subscription. If not set, the default retry policy is applied. This generally implies that messages will be retried as soon as possible for healthy subscribers. RetryPolicy will be triggered on NACKs or acknowledgement deadline exceeded events for a given message
      retry_policy = optional(object({
        minimum_backoff = string
        maximum_backoff = string
      }))

      # Indicates whether to retain acknowledged messages. If true, then messages are not expunged from the subscription's backlog, even if they are acknowledged, until they fall out of the messageRetentionDuration window.
      retain_acked_messages = optional(bool)
    }))

    # threshold for high message alarms for consumer's queue. defaults to 5000.
    high_message_count_threshold = optional(number)

    # Override list of Stackdriver notification channels for dead-letter queue non-empty alert
    dlq_alert_notification_channels = optional(list(string))

    # Override list of Stackdriver notification channels for queue high message count alert
    queue_alert_notification_channels = optional(list(string))

    # A policy that specifies how Pub/Sub retries message delivery for this subscription. If not set, the default retry policy is applied. This generally implies that messages will be retried as soon as possible for healthy subscribers. RetryPolicy will be triggered on NACKs or acknowledgement deadline exceeded events for a given message
    retry_policy = optional(object({
      minimum_backoff = string
      maximum_backoff = string
    }))
  }))
}

variable "topics" {
  description = "List of Hedwig topics"
  default     = {}
  type = map(object({
    # DEPRECATED: use `iam_members` instead
    # service accounts for publishing permissions
    service_accounts = optional(list(string), [])

    # IAM members for publishing permissions
    iam_members = optional(list(string), [])

    # Enable firehose for topic—that is, save all published messages to Cloud Storage
    firehose_config = optional(object({
      bucket            = string
      filename_prefix   = optional(string)
      filename_suffix   = optional(string)
      max_duration      = optional(string)
      max_bytes         = optional(number)
      write_avro_format = optional(bool)
    }))
  }))
}
