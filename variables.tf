variable "dataflow_tmp_gcs_location" {
  default     = ""
  description = "A gs bucket location for storing temporary files by Google Dataflow, e.g. gs://myBucket/tmp"
}

variable "dataflow_template_pubsub_to_storage_gcs_path" {
  default     = "gs://dataflow-templates/2019-04-03-00/Cloud_PubSub_to_GCS_Text"
  description = "The template path for Google Dataflow, e.g. gs://dataflow-templates/2019-04-24-00/Cloud_PubSub_to_GCS_Text"
}

variable "dataflow_zone" {
  default     = ""
  description = "The zone to use for Dataflow. This may be required if it's not set at the provider level, or that zone doesn't support Dataflow regional endpoints (see https://cloud.google.com/dataflow/docs/concepts/regional-endpoints)"
}

variable "dataflow_region" {
  default     = ""
  description = "The region to use for Dataflow. This may be required if it's not set at the provider level, or you want to use a region different from the zone (see https://cloud.google.com/dataflow/docs/concepts/regional-endpoints)"
}

variable "dataflow_output_directory" {
  default     = ""
  description = "A gs bucket location for storing output files by Google Dataflow, e.g. gs://myBucket/hedwigBackup"
}

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

variable "dataflow_alert_notification_channels" {
  default     = []
  type        = list(string)
  description = "List of Stackdriver notification channels for Firehose dataflow data freshness stale alert"
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
    subscriptions = map(object({
      # for cross-project subscriptions, set to topic's project id
      project = optional(string)

      # ordered queues (https://cloud.google.com/pubsub/docs/ordering)
      enable_ordering = optional(bool)

      # threshold for high message alarms for this subscription. defaults to 5000.
      high_message_count_threshold = optional(number)
    }))

    # threshold for high message alarms for consumer's queue. defaults to 5000.
    high_message_count_threshold = optional(number)
  }))
}

variable "topics" {
  description = "List of Hedwig topics"
  default     = {}
  type = map(object({
    # Firehose all messages published to this topic into GCS
    enable_firehose = optional(bool)

    # service accounts for publishing permissions
    service_accounts = optional(list(string))
  }))
}
