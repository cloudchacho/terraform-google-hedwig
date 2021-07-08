module "topics" {
  for_each = var.topics

  source  = "cloudchacho/hedwig-topic/google"
  version = ">= 2, <3"

  topic = each.key

  enable_firehose_all_messages = var.enable_firehose_all_topics || each.value.enable_firehose == true

  iam_service_accounts = each.value.service_accounts != null ? each.value.service_accounts : []

  enable_alerts    = var.enable_alerts
  alerting_project = var.alerting_project

  dataflow_freshness_alert_notification_channels = var.dataflow_alert_notification_channels
  dataflow_tmp_gcs_location                      = var.dataflow_tmp_gcs_location
  dataflow_template_gcs_path                     = var.dataflow_template_pubsub_to_storage_gcs_path
  dataflow_zone                                  = var.dataflow_zone
  dataflow_region                                = var.dataflow_region
  dataflow_output_directory                      = var.dataflow_output_directory
}
