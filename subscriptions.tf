module "subscriptions" {
  for_each = local.subscriptions

  source  = "cloudchacho/hedwig-subscription/google"
  version = ">= 3.5, <4"

  queue                   = each.value.queue
  topic                   = each.value.project != null ? "projects/${each.value.project}/topics/hedwig-${each.value.topic}" : module.topics[each.value.topic].name
  enable_message_ordering = each.value.enable_ordering
  iam_service_account     = each.value.service_account
  disable_dlq             = each.value.disable_dlq
  filter                  = each.value.filter
  max_delivery_attempts   = each.value.max_delivery_attempts
  retry_policy            = each.value.retry_policy
  retain_acked_messages   = each.value.retain_acked_messages

  labels = each.value.labels
}
